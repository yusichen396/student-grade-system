package com.student.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.student.common.api.CommonResult;
import com.student.dto.StudentParam;
import com.student.model.Student;
import com.student.service.StudentService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/student")
public class StudentController {
    @Resource
    private StudentService studentService;

    @PostMapping
    public CommonResult<Boolean> create(@Valid @RequestBody StudentParam param) {
        boolean success = studentService.create(param);
        if (success) {
            return CommonResult.success(true);
        }
        return CommonResult.failed();
    }

    @PutMapping("/{id}")
    public CommonResult<Boolean> update(@PathVariable Long id, @Valid @RequestBody StudentParam param) {
        boolean success = studentService.update(id, param);
        if (success) {
            return CommonResult.success(true);
        }
        return CommonResult.failed();
    }

    @DeleteMapping("/{id}")
    public CommonResult<Boolean> delete(@PathVariable Long id) {
        boolean success = studentService.delete(id);
        if (success) {
            return CommonResult.success(true);
        }
        return CommonResult.failed();
    }

    @DeleteMapping("/batch")
    public CommonResult<Boolean> deleteBatch(@RequestBody List<Long> ids) {
        boolean success = studentService.deleteBatch(ids);
        if (success) {
            return CommonResult.success(true);
        }
        return CommonResult.failed();
    }

    @GetMapping("/list")
    public CommonResult<Page<Student>> list(@RequestParam(value = "keyword", required = false) String keyword,
                                          @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
                                          @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        Page<Student> studentList = studentService.list(keyword, pageNum, pageSize);
        return CommonResult.success(studentList);
    }

    @GetMapping("/{id}")
    public CommonResult<Student> getItem(@PathVariable Long id) {
        Student student = studentService.getItem(id);
        return CommonResult.success(student);
    }
} 