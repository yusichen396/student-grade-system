package com.student.dto;

import lombok.Data;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;

@Data
public class StudentParam {
    @NotEmpty(message = "学号不能为空")
    private String studentId;
    
    @NotEmpty(message = "姓名不能为空")
    private String name;
    
    @NotNull(message = "性别不能为空")
    private Integer gender;
    
    private Date birthDate;
    
    private String idCard;
    
    private String email;
    
    private String phone;
    
    private String address;
    
    @NotNull(message = "班级不能为空")
    private Long classId;
} 