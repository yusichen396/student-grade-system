<template>
  <div class="user-management">
    <a-card>
      <!-- 搜索区域 -->
      <div class="search-area">
        <a-form :model="searchForm" layout="inline">
          <a-form-item field="username" label="用户名">
            <a-input v-model="searchForm.username" placeholder="请输入用户名" />
          </a-form-item>
          <a-form-item field="name" label="姓名">
            <a-input v-model="searchForm.name" placeholder="请输入姓名" />
          </a-form-item>
          <a-form-item field="role" label="角色">
            <a-select v-model="searchForm.role" placeholder="请选择角色">
              <a-option value="admin">管理员</a-option>
              <a-option value="teacher">教师</a-option>
              <a-option value="staff">职工</a-option>
            </a-select>
          </a-form-item>
          <a-form-item field="status" label="状态">
            <a-select v-model="searchForm.status" placeholder="请选择状态">
              <a-option value="1">正常</a-option>
              <a-option value="0">禁用</a-option>
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
            新增用户
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
            <a-button 
              type="text" 
              size="small" 
              :status="record.status === 1 ? 'danger' : 'success'"
              @click="handleToggleStatus(record)"
            >
              <template #icon>
                <icon-poweroff v-if="record.status === 1" />
                <icon-play-circle v-else />
              </template>
              {{ record.status === 1 ? '禁用' : '启用' }}
            </a-button>
            <a-button type="text" size="small" @click="handleResetPassword(record)">
              <template #icon><icon-lock /></template>
              重置密码
            </a-button>
            <a-popconfirm
              content="确定要删除这个用户吗？"
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
        <a-form-item field="username" label="用户名" :rules="[{ required: true, message: '请输入用户名' }]">
          <a-input v-model="formData.username" placeholder="请输入用户名" :disabled="!!formData.id" />
        </a-form-item>
        <a-form-item 
          v-if="!formData.id" 
          field="password" 
          label="密码" 
          :rules="[{ required: true, message: '请输入密码' }]"
        >
          <a-input-password v-model="formData.password" placeholder="请输入密码" />
        </a-form-item>
        <a-form-item field="name" label="姓名" :rules="[{ required: true, message: '请输入姓名' }]">
          <a-input v-model="formData.name" placeholder="请输入姓名" />
        </a-form-item>
        <a-form-item field="role" label="角色" :rules="[{ required: true, message: '请选择角色' }]">
          <a-select v-model="formData.role" placeholder="请选择角色">
            <a-option value="admin">管理员</a-option>
            <a-option value="teacher">教师</a-option>
            <a-option value="staff">职工</a-option>
          </a-select>
        </a-form-item>
        <a-form-item field="email" label="邮箱">
          <a-input v-model="formData.email" placeholder="请输入邮箱" />
        </a-form-item>
        <a-form-item field="phone" label="手机号">
          <a-input v-model="formData.phone" placeholder="请输入手机号" />
        </a-form-item>
        <a-form-item field="remark" label="备注">
          <a-textarea v-model="formData.remark" placeholder="请输入备注" />
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
  username: '',
  name: '',
  role: undefined,
  status: undefined
})

// 表格配置
const columns = [
  { title: '用户名', dataIndex: 'username' },
  { title: '姓名', dataIndex: 'name' },
  { title: '角色', dataIndex: 'roleName' },
  { title: '邮箱', dataIndex: 'email' },
  { title: '手机号', dataIndex: 'phone' },
  { title: '状态', dataIndex: 'status', slotName: 'status' },
  { title: '创建时间', dataIndex: 'createTime' },
  { title: '操作', slotName: 'operations', width: 260, fixed: 'right' }
]

// 模拟数据
const tableData = ref([
  {
    id: 1,
    username: 'admin',
    name: '系统管理员',
    roleName: '管理员',
    email: 'admin@example.com',
    phone: '13800138000',
    status: 1,
    createTime: '2024-03-15 14:30:00'
  }
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
const dialogTitle = ref('新增用户')
const formRef = ref(null)
const formData = reactive({
  username: '',
  password: '',
  name: '',
  role: undefined,
  email: '',
  phone: '',
  remark: ''
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

// 新增用户
const handleAdd = () => {
  dialogTitle.value = '新增用户'
  dialogVisible.value = true
}

// 编辑用户
const handleEdit = (record) => {
  dialogTitle.value = '编辑用户'
  Object.assign(formData, record)
  dialogVisible.value = true
}

// 切换用户状态
const handleToggleStatus = (record) => {
  const action = record.status === 1 ? '禁用' : '启用'
  Message.success(`${action}用户：${record.name}`)
}

// 重置密码
const handleResetPassword = (record) => {
  Message.success(`重置密码：${record.name}`)
}

// 删除用户
const handleDelete = (record) => {
  Message.success(`删除用户：${record.name}`)
}

// 批量删除
const handleBatchDelete = () => {
  Message.warning('批量删除功能待实现')
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
.user-management {
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