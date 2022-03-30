<template>
  <div>
    <a-card class="card" size="small">
      <template #title>
        <a-row class="title" type="flex" justify="space-between">
          <a-col :span="6">
            <div class="title">{{title}}</div>
          </a-col>
          <a-col :span="12">
            <div class="title-additional"><slot name="title-additional"/></div>
          </a-col>
        </a-row>
      </template>
      <div class="card-body">
        <a-row class="info" v-for="infoItem in combinedInfo" :key="infoItem.key && infoItem.title">
          <h3>{{infoItem.title}}</h3>
          <component :is="infoItem.type || 'normalInfo'" :info="infoItem.info"/>
        </a-row>
      </div>
    </a-card>
  </div>
</template>

<script>
import MemoryUsageInfo from './MemoryUsageInfo.vue'
import NormalInfo from './NormalInfo.vue'
export default {
  props: ['title', 'combinedInfo'],
  components: {
    MemoryUsageInfo,
    NormalInfo
  }
}
</script>

<style scoped>
  .info:not(:last-child){
    border-bottom: 1px solid rgb(192, 192, 192);
  }
  .card{
    width: 100%;
    height: 410px;
  }
  .card-body{
    overflow-y: auto;
    overflow-x: hidden;
    height: 360px;
  }
  .title{
    height: 24px;
  }
</style>
