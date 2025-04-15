<template>
  <div class="student-management">
    <a-card>
      <!-- 搜索区域 -->
      <div class="search-area">
        <a-form :model="searchForm" layout="inline">
          <a-form-item>
            <a-input v-model="searchForm.keyword" placeholder="请输入学号/姓名" allow-clear>
              <template #prefix>
                <icon-search />
              </template>
            </a-input>
          </a-form-item>
          <a-form-item>
            <a-space>
              <a-button type="primary" @click="handleSearch">
                <template #icon><icon-search /></template>
                搜索
              </a-button>
              <a-button @click="resetSearch">
                <template #icon><icon-refresh /></template>
                重置
              </a-button>
            </a-space>
          </a-form-item>
        </a-form>
      </div>

      <!-- 操作按钮区域 -->
      <div class="operation-area">
        <a-space>
          <a-button type="primary" @click="handleAdd">
            <template #icon><icon-plus /></template>
            新增学生
          </a-button>
          <a-button status="danger" @click="handleBatchDelete" :disabled="selectedKeys.length === 0">
            <template #icon><icon-delete /></template>
            批量删除
          </a-button>
        </a-space>
      </div>

      <!-- 表格区域 -->
      <a-table
        :columns="columns"
        :data="tableData"
        :pagination="pagination"
        :loading="loading"
        :row-selection="{
          type: 'checkbox',
          showCheckedAll: true,
          onlyCurrent: true,
          selected: selectedKeys
        }"
        @page-change="onPageChange"
      >
        <template #gender="{ record }">
          {{ record.gender === 1 ? '男' : '女' }}
        </template>
        <template #status="{ record }">
          <a-tag :color="record.status === 1 ? 'green' : 'red'">
            {{ record.status === 1 ? '正常' : '禁用' }}
          </a-tag>
        </template>
        <template #operations="{ record }">
          <a-space>
            <a-button type="text" size="small" @click="handleEdit(record)">
              <template #icon><icon-edit /></template>
              编辑
            </a-button>
            <a-button type="text" status="danger" size="small" @click="handleDelete(record)">
              <template #icon><icon-delete /></template>
              删除
            </a-button>
          </a-space>
        </template>
      </a-table>

      <!-- 新增/编辑对话框 -->
      <a-modal
        v-model:visible="dialogVisible"
        :title="dialogTitle"
        @ok="handleSubmit"
        @cancel="handleCancel"
        :mask-closable="false"
      >
        <a-form
          ref="formRef"
          :model="form"
          :rules="rules"
          layout="vertical"
        >
          <a-form-item field="studentId" label="学号">
            <a-input v-model="form.studentId" placeholder="请输入学号" allow-clear />
          </a-form-item>
          <a-form-item field="name" label="姓名">
            <a-input v-model="form.name" placeholder="请输入姓名" allow-clear />
          </a-form-item>
          <a-form-item field="gender" label="性别">
            <a-radio-group v-model="form.gender">
              <a-radio :value="1">男</a-radio>
              <a-radio :value="2">女</a-radio>
            </a-radio-group>
          </a-form-item>
          <a-form-item field="birthDate" label="出生日期">
            <a-date-picker v-model="form.birthDate" style="width: 100%" />
          </a-form-item>
          <a-form-item field="idCard" label="身份证号">
            <a-input v-model="form.idCard" placeholder="请输入身份证号" allow-clear />
          </a-form-item>
          <a-form-item field="email" label="邮箱">
            <a-input v-model="form.email" placeholder="请输入邮箱" allow-clear />
          </a-form-item>
          <a-form-item field="phone" label="手机号">
            <a-input v-model="form.phone" placeholder="请输入手机号" allow-clear />
          </a-form-item>
          <a-form-item field="address" label="住址">
            <a-input v-model="form.address" placeholder="请输入住址" allow-clear />
          </a-form-item>
          <a-form-item field="classId" label="班级">
            <a-select v-model="form.classId" placeholder="请选择班级">
              <a-option v-for="item in classList" :key="item.id" :value="item.id">
                {{ item.name }}
              </a-option>
            </a-select>
          </a-form-item>
        </a-form>
      </a-modal>
    </a-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { Message, Modal } from '@arco-design/web-vue';
import { getStudentList, createStudent, updateStudent, deleteStudent, deleteBatchStudent } from '@/api/student';
import { getClassList } from '@/api/class';

// 表格列定义
const columns = [
  { title: '学号', dataIndex: 'studentId' },
  { title: '姓名', dataIndex: 'name' },
  { title: '性别', dataIndex: 'gender', slotName: 'gender' },
  { title: '班级', dataIndex: 'className' },
  { title: '手机号', dataIndex: 'phone' },
  { title: '邮箱', dataIndex: 'email' },
  { title: '状态', dataIndex: 'status', slotName: 'status' },
  { title: '操作', slotName: 'operations', width: 150, fixed: 'right' }
];

// 搜索表单
const searchForm = reactive({
  keyword: ''
});

// 表格数据
const tableData = ref([]);
const loading = ref(false);
const pagination = reactive({
  total: 0,
  current: 1,
  pageSize: 10
});

// 选择行配置
const selectedKeys = ref([]);

// 对话框表单
const dialogVisible = ref(false);
const dialogTitle = ref('');
const formRef = ref(null);
const form = reactive({
  studentId: '',
  name: '',
  gender: 1,
  birthDate: null,
  idCard: '',
  email: '',
  phone: '',
  address: '',
  classId: undefined
});

// 表单校验规则
const rules = {
  studentId: [{ required: true, message: '请输入学号' }],
  name: [{ required: true, message: '请输入姓名' }],
  gender: [{ required: true, message: '请选择性别' }],
  classId: [{ required: true, message: '请选择班级' }]
};

// 班级列表
const classList = ref([]);

// 获取班级列表
const fetchClassList = async () => {
  try {
    const res = await getClassList();
    if (res.code === 200) {
      classList.value = res.data;
    }
  } catch (error) {
    console.error('获取班级列表失败:', error);
  }
};

// 获取学生列表
const fetchStudentList = async () => {
  loading.value = true;
  try {
    const res = await getStudentList({
      keyword: searchForm.keyword,
      pageNum: pagination.current,
      pageSize: pagination.pageSize
    });
    if (res.code === 200) {
      tableData.value = res.data.records;
      pagination.total = res.data.total;
    }
  } catch (error) {
    console.error('获取学生列表失败:', error);
  } finally {
    loading.value = false;
  }
};

// 搜索
const handleSearch = () => {
  pagination.current = 1;
  fetchStudentList();
};

// 重置搜索
const resetSearch = () => {
  searchForm.keyword = '';
  handleSearch();
};

// 页码改变
const onPageChange = (current) => {
  pagination.current = current;
  fetchStudentList();
};

// 新增学生
const handleAdd = () => {
  dialogTitle.value = '新增学生';
  Object.keys(form).forEach(key => {
    form[key] = key === 'gender' ? 1 : undefined;
  });
  dialogVisible.value = true;
};

// 编辑学生
const handleEdit = (record) => {
  dialogTitle.value = '编辑学生';
  Object.keys(form).forEach(key => {
    form[key] = record[key];
  });
  dialogVisible.value = true;
};

// 删除学生
const handleDelete = (record) => {
  Modal.warning({
    title: '确认删除',
    content: `确定要删除学生"${record.name}"吗？`,
    onOk: async () => {
      try {
        const res = await deleteStudent(record.id);
        if (res.code === 200) {
          Message.success('删除成功');
          fetchStudentList();
        }
      } catch (error) {
        console.error('删除学生失败:', error);
      }
    }
  });
};

// 批量删除
const handleBatchDelete = () => {
  if (selectedKeys.value.length === 0) return;
  Modal.warning({
    title: '确认删除',
    content: `确定要删除选中的${selectedKeys.value.length}个学生吗？`,
    onOk: async () => {
      try {
        const res = await deleteBatchStudent(selectedKeys.value);
        if (res.code === 200) {
          Message.success('批量删除成功');
          selectedKeys.value = [];
          fetchStudentList();
        }
      } catch (error) {
        console.error('批量删除学生失败:', error);
      }
    }
  });
};

// 提交表单
const handleSubmit = async () => {
  try {
    await formRef.value.validate();
    const submitFunc = dialogTitle.value === '新增学生' ? createStudent : updateStudent;
    const res = await submitFunc(form);
    if (res.code === 200) {
      Message.success(`${dialogTitle.value}成功`);
      dialogVisible.value = false;
      fetchStudentList();
    }
  } catch (error) {
    console.error(`${dialogTitle.value}失败:`, error);
  }
};

// 取消
const handleCancel = () => {
  formRef.value.resetFields();
  dialogVisible.value = false;
};

onMounted(() => {
  fetchClassList();
  fetchStudentList();
});
</script>

<style scoped>
.student-management {
  padding: 20px;
}

.search-area {
  margin-bottom: 16px;
}

.operation-area {
  margin-bottom: 16px;
}
</style> 