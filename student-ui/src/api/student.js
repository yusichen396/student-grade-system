import request from '@/utils/request';

export function getStudentList(params) {
  return request({
    url: '/student/list',
    method: 'get',
    params
  });
}

export function createStudent(data) {
  return request({
    url: '/student',
    method: 'post',
    data
  });
}

export function updateStudent(data) {
  return request({
    url: `/student/${data.id}`,
    method: 'put',
    data
  });
}

export function deleteStudent(id) {
  return request({
    url: `/student/${id}`,
    method: 'delete'
  });
}

export function deleteBatchStudent(ids) {
  return request({
    url: '/student/batch',
    method: 'delete',
    data: ids
  });
} 