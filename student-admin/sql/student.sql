-- 创建数据库
CREATE DATABASE IF NOT EXISTS student_db DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;

USE student_db;

-- 系统用户表
CREATE TABLE sys_user (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    avatar VARCHAR(255) DEFAULT NULL COMMENT '头像',
    email VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 系统角色表
CREATE TABLE sys_role (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    name VARCHAR(50) NOT NULL COMMENT '角色名称',
    code VARCHAR(50) NOT NULL COMMENT '角色编码',
    sort INT(11) DEFAULT 0 COMMENT '显示顺序',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    remark VARCHAR(500) DEFAULT NULL COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统角色表';

-- 用户角色关联表
CREATE TABLE sys_user_role (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    role_id BIGINT(20) NOT NULL COMMENT '角色ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_role (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 系统权限表
CREATE TABLE sys_permission (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    parent_id BIGINT(20) DEFAULT 0 COMMENT '父级ID',
    name VARCHAR(50) NOT NULL COMMENT '权限名称',
    type TINYINT(1) NOT NULL COMMENT '类型：1-目录，2-菜单，3-按钮',
    permission VARCHAR(100) DEFAULT NULL COMMENT '权限标识',
    path VARCHAR(200) DEFAULT NULL COMMENT '路由地址',
    component VARCHAR(255) DEFAULT NULL COMMENT '组件路径',
    icon VARCHAR(100) DEFAULT NULL COMMENT '图标',
    sort INT(11) DEFAULT 0 COMMENT '显示顺序',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统权限表';

-- 角色权限关联表
CREATE TABLE sys_role_permission (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    role_id BIGINT(20) NOT NULL COMMENT '角色ID',
    permission_id BIGINT(20) NOT NULL COMMENT '权限ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_role_permission (role_id, permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 学生信息表
CREATE TABLE student_info (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    student_id VARCHAR(20) NOT NULL COMMENT '学号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender TINYINT(1) NOT NULL COMMENT '性别：1-男，2-女',
    birth_date DATE DEFAULT NULL COMMENT '出生日期',
    id_card VARCHAR(18) DEFAULT NULL COMMENT '身份证号',
    email VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    address VARCHAR(200) DEFAULT NULL COMMENT '住址',
    class_id BIGINT(20) NOT NULL COMMENT '班级ID',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_student_id (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

-- 班级信息表
CREATE TABLE class_info (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    name VARCHAR(50) NOT NULL COMMENT '班级名称',
    grade VARCHAR(20) NOT NULL COMMENT '年级',
    teacher_id BIGINT(20) DEFAULT NULL COMMENT '班主任ID',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级信息表';

-- 课程信息表
CREATE TABLE course_info (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    name VARCHAR(50) NOT NULL COMMENT '课程名称',
    teacher_id BIGINT(20) NOT NULL COMMENT '任课教师ID',
    credit DECIMAL(3,1) DEFAULT 0 COMMENT '学分',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程信息表';

-- 成绩信息表
CREATE TABLE grade_info (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    student_id BIGINT(20) NOT NULL COMMENT '学生ID',
    course_id BIGINT(20) NOT NULL COMMENT '课程ID',
    score DECIMAL(5,2) DEFAULT NULL COMMENT '成绩',
    exam_time DATETIME DEFAULT NULL COMMENT '考试时间',
    status TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    deleted TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_student_course (student_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩信息表';

-- 初始化系统管理员
INSERT INTO sys_user (username, password, name, status) VALUES 
('admin', '$2a$10$VQEpxHbwvQ5LW.JBsDJX8.9N8fZ6yL0lJ0PVpvzC6Nz5r4H3t9Gm2', '系统管理员', 1);

-- 初始化角色
INSERT INTO sys_role (name, code, sort, status, remark) VALUES 
('超级管理员', 'admin', 1, 1, '系统最高权限'),
('教师', 'teacher', 2, 1, '教师权限'),
('学生', 'student', 3, 1, '学生权限');

-- 初始化用户角色关联
INSERT INTO sys_user_role (user_id, role_id) VALUES (1, 1); 