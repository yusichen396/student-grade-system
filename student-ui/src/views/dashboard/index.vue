<template>
  <div class="dashboard">
    <div class="dashboard-header">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="dashboard-card">
            <template #title>
              <div class="card-title">
                <icon-user class="icon" />
                <span>学生总数</span>
              </div>
            </template>
            <div class="card-content">
              <div class="number">2,567</div>
              <div class="desc">较上月增长 12%</div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="dashboard-card">
            <template #title>
              <div class="card-title">
                <icon-calendar class="icon" />
                <span>今日考勤</span>
              </div>
            </template>
            <div class="card-content">
              <div class="number">98%</div>
              <div class="desc">出勤率</div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="dashboard-card">
            <template #title>
              <div class="card-title">
                <icon-book class="icon" />
                <span>课程数量</span>
              </div>
            </template>
            <div class="card-content">
              <div class="number">156</div>
              <div class="desc">本学期开设课程</div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="dashboard-card">
            <template #title>
              <div class="card-title">
                <icon-notification class="icon" />
                <span>待办事项</span>
              </div>
            </template>
            <div class="card-content">
              <div class="number">12</div>
              <div class="desc">需要处理的事项</div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <div class="dashboard-content">
      <a-row :gutter="16">
        <a-col :span="16">
          <a-card class="chart-card" title="学生成绩分布">
            <template #extra>
              <a-radio-group type="button" default-value="week">
                <a-radio value="week">本周</a-radio>
                <a-radio value="month">本月</a-radio>
                <a-radio value="year">本年</a-radio>
              </a-radio-group>
            </template>
            <!-- 这里可以添加图表组件 -->
            <div class="chart-placeholder">
              成绩分布图表
            </div>
          </a-card>
        </a-col>
        <a-col :span="8">
          <a-card class="notice-card" title="系统公告">
            <template #extra>
              <a-button type="text">更多</a-button>
            </template>
            <a-list>
              <a-list-item>
                <a-tag color="blue">通知</a-tag>
                期末考试安排已发布
              </a-list-item>
              <a-list-item>
                <a-tag color="green">活动</a-tag>
                校园文化节即将开始
              </a-list-item>
              <a-list-item>
                <a-tag color="orange">提醒</a-tag>
                请及时提交成绩单
              </a-list-item>
              <a-list-item>
                <a-tag color="red">重要</a-tag>
                系统维护通知
              </a-list-item>
            </a-list>
          </a-card>
          
          <a-card class="todo-card" title="待办事项" style="margin-top: 16px;">
            <template #extra>
              <a-button type="text">添加</a-button>
            </template>
            <a-list>
              <a-list-item>
                <a-checkbox>审核学生请假申请</a-checkbox>
              </a-list-item>
              <a-list-item>
                <a-checkbox>更新教学计划</a-checkbox>
              </a-list-item>
              <a-list-item>
                <a-checkbox>准备教学材料</a-checkbox>
              </a-list-item>
              <a-list-item>
                <a-checkbox>参加教研会议</a-checkbox>
              </a-list-item>
            </a-list>
          </a-card>
        </a-col>
      </a-row>
    </div>
  </div>
</template>

<script setup>
// 仪表盘组件
</script>

<style scoped>
.dashboard {
  padding: 16px;
}

.dashboard-header {
  margin-bottom: 16px;
}

.dashboard-card {
  height: 180px;
  background: linear-gradient(to right bottom, var(--color-bg-2), var(--color-bg-1));
  border: none;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.card-title {
  display: flex;
  align-items: center;
  gap: 8px;
}

.card-title .icon {
  font-size: 20px;
  color: var(--primary-color);
}

.card-content {
  padding: 16px 0;
  text-align: center;
}

.card-content .number {
  font-size: 36px;
  font-weight: bold;
  color: var(--color-text-1);
  line-height: 1.2;
}

.card-content .desc {
  margin-top: 8px;
  color: var(--color-text-3);
}

.chart-card {
  height: 400px;
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

.notice-card, .todo-card {
  height: 192px;
}

:deep(.arco-list-item) {
  padding: 8px 0;
}

:deep(.arco-tag) {
  margin-right: 8px;
}
</style> 