package com.student.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.student.dto.StudentParam;
import com.student.mapper.StudentMapper;
import com.student.model.Student;
import com.student.service.StudentService;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service
public class StudentServiceImpl implements StudentService {
    @Resource
    private StudentMapper studentMapper;

    @Override
    public boolean create(StudentParam param) {
        Student student = new Student();
        BeanUtils.copyProperties(param, student);
        student.setStatus(1);
        return studentMapper.insert(student) > 0;
    }

    @Override
    public boolean update(Long id, StudentParam param) {
        Student student = new Student();
        BeanUtils.copyProperties(param, student);
        student.setId(id);
        return studentMapper.updateById(student) > 0;
    }

    @Override
    public boolean delete(Long id) {
        return studentMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteBatch(List<Long> ids) {
        return studentMapper.deleteBatchIds(ids) > 0;
    }

    @Override
    public Page<Student> list(String keyword, Integer pageNum, Integer pageSize) {
        Page<Student> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Student> wrapper = new LambdaQueryWrapper<>();
        if (StrUtil.isNotEmpty(keyword)) {
            wrapper.like(Student::getName, keyword)
                    .or()
                    .like(Student::getStudentId, keyword);
        }
        return studentMapper.selectPage(page, wrapper);
    }

    @Override
    public Student getItem(Long id) {
        return studentMapper.selectById(id);
    }
} 