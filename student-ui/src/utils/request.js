import axios from 'axios';
import { Message } from '@arco-design/web-vue';

// 创建axios实例
const service = axios.create({
  baseURL: '/api', // API的base_url
  timeout: 15000 // 请求超时时间
});

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 在发送请求之前做些什么
    const token = localStorage.getItem('token');
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token;
    }
    return config;
  },
  error => {
    // 对请求错误做些什么
    console.error('请求错误:', error);
    return Promise.reject(error);
  }
);

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data;
    // 如果返回的状态码不是200，说明接口有问题，把错误信息显示出来
    if (res.code !== 200) {
      Message.error(res.message || '系统错误');
      
      // 401: 未登录或token过期
      if (res.code === 401) {
        // 清除用户信息并跳转到登录页面
        localStorage.removeItem('token');
        location.reload();
      }
      return Promise.reject(new Error(res.message || '系统错误'));
    } else {
      return res;
    }
  },
  error => {
    console.error('响应错误:', error);
    Message.error(error.message || '系统错误');
    return Promise.reject(error);
  }
);

export default service; 