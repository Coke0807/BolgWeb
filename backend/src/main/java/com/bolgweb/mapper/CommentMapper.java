package com.bolgweb.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bolgweb.entity.Comment;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommentMapper extends BaseMapper<Comment> {
}
