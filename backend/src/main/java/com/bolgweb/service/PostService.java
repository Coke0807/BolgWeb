package com.bolgweb.service;

import com.bolgweb.entity.Post;
import com.bolgweb.mapper.PostMapper;
import com.bolgweb.mapper.UserMapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PostService extends ServiceImpl<PostMapper, Post> {

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private UserMapper userMapper;

    public Page<Post> getPostPage(int current, int size, String category, String tag) {
        Page<Post> page = new Page<>(current, size);
        QueryWrapper<Post> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1);
        queryWrapper.orderByDesc("created_at");

        if (category != null && !category.isEmpty()) {
            queryWrapper.eq("category", category);
        }

        if (tag != null && !tag.isEmpty()) {
            queryWrapper.like("tags", tag);
        }

        Page<Post> result = postMapper.selectPage(page, queryWrapper);

        result.getRecords().forEach(post -> {
            var user = userMapper.selectById(post.getAuthorId());
            if (user != null) {
                post.setAuthorNickname(user.getNickname());
                post.setAuthorAvatar(user.getAvatar());
            }
        });

        return result;
    }

    public Post getPostById(Long id) {
        Post post = postMapper.selectById(id);
        if (post != null) {
            var user = userMapper.selectById(post.getAuthorId());
            if (user != null) {
                post.setAuthorNickname(user.getNickname());
                post.setAuthorAvatar(user.getAvatar());
            }
            postMapper.update(null,
                new com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<Post>()
                    .eq(Post::getId, id)
                    .set(Post::getViewCount, post.getViewCount() + 1)
            );
        }
        return post;
    }

    @Transactional
    public boolean createPost(Post post) {
        return postMapper.insert(post) > 0;
    }

    @Transactional
    public boolean updatePost(Post post) {
        return postMapper.updateById(post) > 0;
    }

    @Transactional
    public boolean deletePost(Long id) {
        return postMapper.deleteById(id) > 0;
    }
}
