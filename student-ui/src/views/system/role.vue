<template>
  <div class="role-management">
    <a-card>
      <!-- 搜索区域 -->
      <div class="search-area">
        <a-form :model="searchForm" layout="inline">
          <a-form-item field="name" label="角色名称">
            <a-input v-model="searchForm.name" placeholder="请输入角色名称" />
          </a-form-item>
          <a-form-item field="code" label="角色编码">
            <a-input v-model="searchForm.code" placeholder="请输入角色编码" />
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
            新增角色
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
            <a-button type="text" size="small" @click="handlePermission(record)">
              <template #icon><icon-user-group /></template>
              权限设置
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
            <a-popconfirm
              content="确定要删除这个角色吗？"
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
        <a-form-item field="name" label="角色名称" :rules="[{ required: true, message: '请输入角色名称' }]">
          <a-input v-model="formData.name" placeholder="请输入角色名称" />
        </a-form-item>
        <a-form-item field="code" label="角色编码" :rules="[{ required: true, message: '请输入角色编码' }]">
          <a-input v-model="formData.code" placeholder="请输入角色编码" :disabled="!!formData.id" />
        </a-form-item>
        <a-form-item field="sort" label="显示顺序" :rules="[{ required: true, message: '请输入显示顺序' }]">
          <a-input-number v-model="formData.sort" placeholder="请输入显示顺序" />
        </a-form-item>
        <a-form-item field="remark" label="备注">
          <a-textarea v-model="formData.remark" placeholder="请输入备注" />
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 权限设置弹窗 -->
    <a-modal
      v-model:visible="permissionVisible"
      title="权限设置"
      @ok="handlePermissionSubmit"
      @cancel="closePermissionDialog"
    >
      <a-tree
        ref="permissionTree"
        :data="permissionData"
        :checked-keys="checkedKeys"
        :checked-strategy="'child'"
        checkable
        @check="handlePermissionCheck"
      />
    </a-modal>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Message } from '@arco-design/web-vue'

// 搜索表单
const searchForm = reactive({
  name: '',
  code: '',
  status: undefined
})

// 表格配置
const columns = [
  { title: '角色名称', dataIndex: 'name' },
  { title: '角色编码', dataIndex: 'code' },
  { title: '显示顺序', dataIndex: 'sort' },
  { title: '状态', dataIndex: 'status', slotName: 'status' },
  { title: '创建时间', dataIndex: 'createTime' },
  { title: '备注', dataIndex: 'remark' },
  { title: '操作', slotName: 'operations', width: 340, fixed: 'right' }
]

// 模拟数据
const tableData = ref([
  {
    id: 1,
    name: '超级管理员',
    code: 'admin',
    sort: 1,
    status: 1,
    createTime: '2024-03-15 14:30:00',
    remark: '系统最高权限'
  },
  {
    id: 2,
    name: '教师',
    code: 'teacher',
    sort: 2,
    status: 1,
    createTime: '2024-03-15 14:30:00',
    remark: '教师权限'
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
const dialogTitle = ref('新增角色')
const formRef = ref(null)
const formData = reactive({
  name: '',
  code: '',
  sort: 0,
  remark: ''
})

// 权限设置相关
const permissionVisible = ref(false)
const permissionTree = ref(null)
const checkedKeys = ref([])
const permissionData = [
  {
    title: '系统管理',
    key: 'system',
    children: [
      {
        title: '用户管理',
        key: 'user',
        children: [
          { title: '查看用户', key: 'user:view' },
          { title: '新增用户', key: 'user:add' },
          { title: '编辑用户', key: 'user:edit' },
          { title: '删除用户', key: 'user:delete' }
        ]
      },
      {
        title: '角色管理',
        key: 'role',
        children: [
          { title: '查看角色', key: 'role:view' },
          { title: '新增角色', key: 'role:add' },
          { title: '编辑角色', key: 'role:edit' },
          { title: '删除角色', key: 'role:delete' }
        ]
      }
    ]
  }
]

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

// 新增角色
const handleAdd = () => {
  dialogTitle.value = '新增角色'
  dialogVisible.value = true
}

// 编辑角色
const handleEdit = (record) => {
  dialogTitle.value = '编辑角色'
  Object.assign(formData, record)
  dialogVisible.value = true
}

// 权限设置
const handlePermission = (record) => {
  // TODO: 获取角色权限
  checkedKeys.value = ['user:view', 'role:view']
  permissionVisible.value = true
}

// 权限树选择
const handlePermissionCheck = (checkedKeys) => {
  // TODO: 处理权限选择
}

// 提交权限设置
const handlePermissionSubmit = () => {
  // TODO: 保存权限设置
  Message.success('权限设置成功')
  permissionVisible.value = false
}

// 切换角色状态
const handleToggleStatus = (record) => {
  const action = record.status === 1 ? '禁用' : '启用'
  Message.success(`${action}角色：${record.name}`)
}

// 删除角色
const handleDelete = (record) => {
  Message.success(`删除角色：${record.name}`)
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

// 关闭权限设置弹窗
const closePermissionDialog = () => {
  permissionVisible.value = false
  checkedKeys.value = []
}
</script>

<style scoped>
.role-management {
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