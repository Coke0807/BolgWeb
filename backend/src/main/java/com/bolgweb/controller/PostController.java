package com.bolgweb.controller;

import com.bolgweb.dto.ApiResponse;
import com.bolgweb.entity.Post;
import com.bolgweb.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping
    public ApiResponse<Page<Post>> getPosts(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String tag) {
        Page<Post> page = postService.getPostPage(current, size, category, tag);
        return ApiResponse.success(page);
    }

    @GetMapping("/{id}")
    public ApiResponse<Post> getPost(@PathVariable Long id) {
        Post post = postService.getPostById(id);
        if (post == null) {
            return ApiResponse.error(404, "文章不存在");
        }
        return ApiResponse.success(post);
    }

    @PostMapping
    public ApiResponse<Boolean> createPost(@RequestBody Post post) {
        boolean result = postService.createPost(post);
        return result ? ApiResponse.success("创建成功", true) : ApiResponse.error("创建失败");
    }

    @PutMapping("/{id}")
    public ApiResponse<Boolean> updatePost(@PathVariable Long id, @RequestBody Post post) {
        post.setId(id);
        boolean result = postService.updatePost(post);
        return result ? ApiResponse.success("更新成功", true) : ApiResponse.error("更新失败");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> deletePost(@PathVariable Long id) {
        boolean result = postService.deletePost(id);
        return result ? ApiResponse.success("删除成功", true) : ApiResponse.error("删除失败");
    }
}
