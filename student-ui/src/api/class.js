import request from '@/utils/request';

// 获取班级列表
export function getClassList(params) {
  return request({
    url: '/class/list',
    method: 'get',
    params
  });
}

// 获取班级详情
export function getClassDetail(id) {
  return request({
    url: `/class/${id}`,
    method: 'get'
  });
}

// 创建班级
export function createClass(data) {
  return request({
    url: '/class',
    method: 'post',
    data
  });
}

// 更新班级
export function updateClass(id, data) {
  return request({
    url: `/class/${id}`,
    method: 'put',
    data
  });
}

// 删除班级
export function deleteClass(id) {
  return request({
    url: `/class/${id}`,
    method: 'delete'
  });
} 