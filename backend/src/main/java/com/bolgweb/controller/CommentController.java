package com.bolgweb.controller;

import com.bolgweb.dto.ApiResponse;
import com.bolgweb.entity.Comment;
import com.bolgweb.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/comments")
public class CommentController {

    @Autowired
    private CommentService commentService;

    @GetMapping("/post/{postId}")
    public ApiResponse<List<Comment>> getCommentsByPostId(@PathVariable Long postId) {
        List<Comment> comments = commentService.getCommentsByPostId(postId);
        return ApiResponse.success(comments);
    }

    @PostMapping
    public ApiResponse<Boolean> addComment(@RequestBody Comment comment) {
        boolean result = commentService.addComment(comment);
        return result ? ApiResponse.success("评论成功", true) : ApiResponse.error("评论失败");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> deleteComment(@PathVariable Long id) {
        boolean result = commentService.deleteComment(id);
        return result ? ApiResponse.success("删除成功", true) : ApiResponse.error("删除失败");
    }
}
