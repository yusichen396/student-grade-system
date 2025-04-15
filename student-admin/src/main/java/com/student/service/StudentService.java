package com.student.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.student.dto.StudentParam;
import com.student.model.Student;
import java.util.List;

public interface StudentService {
    /**
     * 添加学生
     */
    boolean create(StudentParam param);

    /**
     * 修改学生
     */
    boolean update(Long id, StudentParam param);

    /**
     * 删除学生
     */
    boolean delete(Long id);

    /**
     * 批量删除学生
     */
    boolean deleteBatch(List<Long> ids);

    /**
     * 分页查询学生
     */
    Page<Student> list(String keyword, Integer pageNum, Integer pageSize);

    /**
     * 获取学生详情
     */
    Student getItem(Long id);
} 