package com.student.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.util.Date;

@Data
@TableName("student_info")
public class Student {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    
    private String studentId;
    
    private String name;
    
    private Integer gender;
    
    private Date birthDate;
    
    private String idCard;
    
    private String email;
    
    private String phone;
    
    private String address;
    
    private Long classId;
    
    private Integer status;
    
    @TableLogic
    private Integer deleted;
    
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
} 