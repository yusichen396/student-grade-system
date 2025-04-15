<template>
  <div class="student-list">
    <a-card>
      <!-- 搜索区域 -->
      <div class="search-area">
        <a-form :model="searchForm" layout="inline">
          <a-form-item field="name" label="姓名">
            <a-input v-model="searchForm.name" placeholder="请输入学生姓名" />
          </a-form-item>
          <a-form-item field="studentId" label="学号">
            <a-input v-model="searchForm.studentId" placeholder="请输入学号" />
          </a-form-item>
          <a-form-item field="class" label="班级">
            <a-select v-model="searchForm.class" placeholder="请选择班级">
              <a-option value="1">一年级一班</a-option>
              <a-option value="2">一年级二班</a-option>
              <a-option value="3">二年级一班</a-option>
              <a-option value="4">二年级二班</a-option>
            </a-select>
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
          <a-button @click="handleExport">
            <template #icon><icon-download /></template>
            导出
          </a-button>
          <a-button status="danger" @click="handleBatchDelete">
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
        :row-selection="rowSelection"
        @page-change="onPageChange"
      >
        <template #gender="{ record }">
          {{ record.gender === 1 ? '男' : '女' }}
        </template>
        <template #operations="{ record }">
          <a-space>
            <a-button type="text" size="small" @click="handleEdit(record)">
              <template #icon><icon-edit /></template>
              编辑
            </a-button>
            <a-button type="text" size="small" @click="handleView(record)">
              <template #icon><icon-eye /></template>
              查看
            </a-button>
            <a-popconfirm
              content="确定要删除这条记录吗？"
              @ok="handleDelete(record)"
            >
              <a-button type="text" status="danger" size="small">
                <template #icon><icon-delete /></template>
                删除
              </a-button>
            </a-popconfirm>
          </a-space>
        </template>
      </a-table>
    </a-card>

    <!-- 新增/编辑弹窗 -->
    <a-modal
      v-model:visible="dialogVisible"
      :title="dialogTitle"
      @ok="handleSubmit"
      @cancel="closeDialog"
    >
      <a-form
        ref="formRef"
        :model="formData"
        :rules="rules"
        layout="vertical"
      >
        <a-form-item field="name" label="姓名" :rules="[{ required: true, message: '请输入姓名' }]">
          <a-input v-model="formData.name" placeholder="请输入姓名" />
        </a-form-item>
        <a-form-item field="studentId" label="学号" :rules="[{ required: true, message: '请输入学号' }]">
          <a-input v-model="formData.studentId" placeholder="请输入学号" />
        </a-form-item>
        <a-form-item field="gender" label="性别" :rules="[{ required: true, message: '请选择性别' }]">
          <a-radio-group v-model="formData.gender">
            <a-radio :value="1">男</a-radio>
            <a-radio :value="2">女</a-radio>
          </a-radio-group>
        </a-form-item>
        <a-form-item field="class" label="班级" :rules="[{ required: true, message: '请选择班级' }]">
          <a-select v-model="formData.class" placeholder="请选择班级">
            <a-option value="1">一年级一班</a-option>
            <a-option value="2">一年级二班</a-option>
            <a-option value="3">二年级一班</a-option>
            <a-option value="4">二年级二班</a-option>
          </a-select>
        </a-form-item>
        <a-form-item field="phone" label="联系电话">
          <a-input v-model="formData.phone" placeholder="请输入联系电话" />
        </a-form-item>
        <a-form-item field="email" label="邮箱">
          <a-input v-model="formData.email" placeholder="请输入邮箱" />
        </a-form-item>
        <a-form-item field="address" label="住址">
          <a-textarea v-model="formData.address" placeholder="请输入住址" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Message } from '@arco-design/web-vue'

// 搜索表单
const searchForm = reactive({
  name: '',
  studentId: '',
  class: undefined
})

// 表格配置
const columns = [
  { title: '学号', dataIndex: 'studentId' },
  { title: '姓名', dataIndex: 'name' },
  { title: '性别', dataIndex: 'gender', slotName: 'gender' },
  { title: '班级', dataIndex: 'className' },
  { title: '联系电话', dataIndex: 'phone' },
  { title: '邮箱', dataIndex: 'email' },
  { title: '操作', slotName: 'operations', width: 200, fixed: 'right' }
]

// 模拟数据
const tableData = ref([
  {
    id: 1,
    studentId: '2024001',
    name: '张三',
    gender: 1,
    className: '一年级一班',
    phone: '13800138000',
    email: 'zhangsan@example.com'
  },
  // 更多数据...
])

const loading = ref(false)
const pagination = reactive({
  total: 100,
  current: 1,
  pageSize: 10
})

// 表格选择配置
const rowSelection = {
  type: 'checkbox',
  showCheckedAll: true,
  onlyCurrent: false
}

// 弹窗相关
const dialogVisible = ref(false)
const dialogTitle = ref('新增学生')
const formRef = ref(null)
const formData = reactive({
  name: '',
  studentId: '',
  gender: 1,
  class: undefined,
  phone: '',
  email: '',
  address: ''
})

// 搜索处理
const handleSearch = () => {
  // TODO: 实现搜索逻辑
  Message.success('搜索')
}

const resetSearch = () => {
  Object.keys(searchForm).forEach(key => {
    searchForm[key] = ''
  })
}

// 新增学生
const handleAdd = () => {
  dialogTitle.value = '新增学生'
  dialogVisible.value = true
}

// 编辑学生
const handleEdit = (record) => {
  dialogTitle.value = '编辑学生'
  Object.assign(formData, record)
  dialogVisible.value = true
}

// 查看学生
const handleView = (record) => {
  Message.info(`查看学生：${record.name}`)
}

// 删除学生
const handleDelete = (record) => {
  Message.success(`删除学生：${record.name}`)
}

// 批量删除
const handleBatchDelete = () => {
  Message.warning('批量删除功能待实现')
}

// 导出
const handleExport = () => {
  Message.success('导出功能待实现')
}

// 分页变化
const onPageChange = (current) => {
  pagination.current = current
}

// 提交表单
const handleSubmit = async () => {
  try {
    await formRef.value.validate()
    Message.success('提交成功')
    dialogVisible.value = false
  } catch (error) {
    // 表单验证失败
  }
}

// 关闭弹窗
const closeDialog = () => {
  dialogVisible.value = false
  formRef.value?.resetFields()
}
</script>

<style scoped>
.student-list {
  padding: 16px;
}

.search-area {
  margin-bottom: 16px;
  padding: 16px;
  background: var(--color-bg-2);
  border-radius: 4px;
}

.operation-area {
  margin-bottom: 16px;
}
</style> 