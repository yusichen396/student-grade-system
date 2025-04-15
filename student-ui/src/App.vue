<script setup>
// App.vue
</script>

<template>
  <a-config-provider>
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </a-config-provider>
</template>

<style>
#app {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}
</style>
