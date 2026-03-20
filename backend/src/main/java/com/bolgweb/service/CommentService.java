package com.bolgweb.service;

import com.bolgweb.entity.Comment;
import com.bolgweb.mapper.CommentMapper;
import com.bolgweb.mapper.UserMapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class CommentService extends ServiceImpl<CommentMapper, Comment> {

    @Autowired
    private CommentMapper commentMapper;

    @Autowired
    private UserMapper userMapper;

    public List<Comment> getCommentsByPostId(Long postId) {
        QueryWrapper<Comment> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id", postId);
        queryWrapper.eq("status", 1);
        queryWrapper.orderByAsc("created_at");

        List<Comment> comments = commentMapper.selectList(queryWrapper);

        comments.forEach(comment -> {
            var user = userMapper.selectById(comment.getUserId());
            if (user != null) {
                comment.setUserNickname(user.getNickname());
                comment.setUserAvatar(user.getAvatar());
            }
            if (comment.getReplyTo() != null) {
                var replyUser = userMapper.selectById(comment.getReplyTo());
                if (replyUser != null) {
                    comment.setReplyToNickname(replyUser.getNickname());
                }
            }
        });

        return comments;
    }

    @Transactional
    public boolean addComment(Comment comment) {
        boolean result = commentMapper.insert(comment) > 0;
        if (result) {
            var postWrapper = new com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<com.bolgweb.entity.Post>()
                .eq(com.bolgweb.entity.Post::getId, comment.getPostId())
                .setSql("comment_count = comment_count + 1");
            postMapper.update(null, postWrapper);
        }
        return result;
    }

    @Transactional
    public boolean deleteComment(Long id) {
        Comment comment = commentMapper.selectById(id);
        if (comment != null) {
            var postWrapper = new com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<com.bolgweb.entity.Post>()
                .eq(com.bolgweb.entity.Post::getId, comment.getPostId())
                .setSql("comment_count = comment_count - 1");
            postMapper.update(null, postWrapper);
        }
        return commentMapper.deleteById(id) > 0;
    }

    @Autowired
    private com.bolgweb.mapper.PostMapper postMapper;
}
