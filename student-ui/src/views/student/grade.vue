<template>
  <div class="grade-management">
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
          <a-form-item field="subject" label="科目">
            <a-select v-model="searchForm.subject" placeholder="请选择科目">
              <a-option value="chinese">语文</a-option>
              <a-option value="math">数学</a-option>
              <a-option value="english">英语</a-option>
              <a-option value="physics">物理</a-option>
              <a-option value="chemistry">化学</a-option>
            </a-select>
          </a-form-item>
          <a-form-item field="semester" label="学期">
            <a-select v-model="searchForm.semester" placeholder="请选择学期">
              <a-option value="2023-1">2023学年第一学期</a-option>
              <a-option value="2023-2">2023学年第二学期</a-option>
              <a-option value="2024-1">2024学年第一学期</a-option>
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
            录入成绩
          </a-button>
          <a-button @click="handleBatchImport">
            <template #icon><icon-upload /></template>
            批量导入
          </a-button>
          <a-button @click="handleExport">
            <template #icon><icon-download /></template>
            导出成绩
          </a-button>
        </a-space>
      </div>

      <!-- 表格区域 -->
      <a-table
        :columns="columns"
        :data="tableData"
        :pagination="pagination"
        :loading="loading"
        @page-change="onPageChange"
      >
        <template #score="{ record }">
          <span :style="{ color: getScoreColor(record.score) }">
            {{ record.score }}
          </span>
        </template>
        <template #operations="{ record }">
          <a-space>
            <a-button type="text" size="small" @click="handleEdit(record)">
              <template #icon><icon-edit /></template>
              编辑
            </a-button>
            <a-button type="text" size="small" @click="handleAnalysis(record)">
              <template #icon><icon-bar-chart /></template>
              分析
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

    <!-- 成绩录入/编辑弹窗 -->
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
        <a-form-item field="studentId" label="学号" :rules="[{ required: true, message: '请输入学号' }]">
          <a-input v-model="formData.studentId" placeholder="请输入学号" />
        </a-form-item>
        <a-form-item field="name" label="姓名" :rules="[{ required: true, message: '请输入姓名' }]">
          <a-input v-model="formData.name" placeholder="请输入姓名" />
        </a-form-item>
        <a-form-item field="subject" label="科目" :rules="[{ required: true, message: '请选择科目' }]">
          <a-select v-model="formData.subject" placeholder="请选择科目">
            <a-option value="chinese">语文</a-option>
            <a-option value="math">数学</a-option>
            <a-option value="english">英语</a-option>
            <a-option value="physics">物理</a-option>
            <a-option value="chemistry">化学</a-option>
          </a-select>
        </a-form-item>
        <a-form-item field="score" label="分数" :rules="[
          { required: true, message: '请输入分数' },
          { type: 'number', min: 0, max: 100, message: '分数范围为0-100' }
        ]">
          <a-input-number v-model="formData.score" :min="0" :max="100" placeholder="请输入分数" />
        </a-form-item>
        <a-form-item field="examDate" label="考试日期" :rules="[{ required: true, message: '请选择考试日期' }]">
          <a-date-picker v-model="formData.examDate" style="width: 100%" />
        </a-form-item>
        <a-form-item field="remark" label="备注">
          <a-textarea v-model="formData.remark" placeholder="请输入备注" />
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 成绩分析弹窗 -->
    <a-modal
      v-model:visible="analysisVisible"
      title="成绩分析"
      @cancel="closeAnalysis"
    >
      <div class="analysis-content">
        <div class="analysis-item">
          <span class="label">班级排名：</span>
          <span class="value">5/42</span>
        </div>
        <div class="analysis-item">
          <span class="label">年级排名：</span>
          <span class="value">28/156</span>
        </div>
        <div class="analysis-item">
          <span class="label">较上次变化：</span>
          <span class="value up">+5分</span>
        </div>
        <div class="chart-area">
          <!-- 这里可以添加成绩趋势图表 -->
          <div class="chart-placeholder">成绩趋势图表</div>
        </div>
      </div>
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
  subject: undefined,
  semester: undefined
})

// 表格配置
const columns = [
  { title: '学号', dataIndex: 'studentId' },
  { title: '姓名', dataIndex: 'name' },
  { title: '科目', dataIndex: 'subject' },
  { title: '分数', dataIndex: 'score', slotName: 'score' },
  { title: '考试日期', dataIndex: 'examDate' },
  { title: '录入时间', dataIndex: 'createTime' },
  { title: '操作', slotName: 'operations', width: 200, fixed: 'right' }
]

// 模拟数据
const tableData = ref([
  {
    id: 1,
    studentId: '2024001',
    name: '张三',
    subject: '数学',
    score: 95,
    examDate: '2024-03-15',
    createTime: '2024-03-15 14:30:00'
  },
  // 更多数据...
])

const loading = ref(false)
const pagination = reactive({
  total: 100,
  current: 1,
  pageSize: 10
})

// 弹窗相关
const dialogVisible = ref(false)
const dialogTitle = ref('录入成绩')
const formRef = ref(null)
const formData = reactive({
  studentId: '',
  name: '',
  subject: undefined,
  score: null,
  examDate: null,
  remark: ''
})

// 分析弹窗
const analysisVisible = ref(false)

// 获取分数颜色
const getScoreColor = (score) => {
  if (score >= 90) return '#52c41a'
  if (score >= 60) return '#1890ff'
  return '#f5222d'
}

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

// 录入成绩
const handleAdd = () => {
  dialogTitle.value = '录入成绩'
  dialogVisible.value = true
}

// 编辑成绩
const handleEdit = (record) => {
  dialogTitle.value = '编辑成绩'
  Object.assign(formData, record)
  dialogVisible.value = true
}

// 成绩分析
const handleAnalysis = (record) => {
  analysisVisible.value = true
}

// 删除成绩
const handleDelete = (record) => {
  Message.success(`删除成绩记录：${record.name}-${record.subject}`)
}

// 批量导入
const handleBatchImport = () => {
  Message.info('批量导入功能待实现')
}

// 导出成绩
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

// 关闭分析弹窗
const closeAnalysis = () => {
  analysisVisible.value = false
}
</script>

<style scoped>
.grade-management {
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

.analysis-content {
  padding: 16px;
}

.analysis-item {
  margin-bottom: 16px;
  display: flex;
  align-items: center;
}

.analysis-item .label {
  width: 100px;
  color: var(--color-text-3);
}

.analysis-item .value {
  font-size: 16px;
  font-weight: 500;
}

.analysis-item .value.up {
  color: #52c41a;
}

.analysis-item .value.down {
  color: #f5222d;
}

.chart-area {
  margin-top: 24px;
}

.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-bg-2);
  border-radius: 4px;
  color: var(--color-text-3);
}
</style> 