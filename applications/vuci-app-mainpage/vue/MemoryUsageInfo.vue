<template>
  <a-row :gutter="[12, 0]">
    <a-col :span="24/Object.keys(info).length" class="memory" v-for="memory in info" :key="memory.title">
      <h6 class="title">{{memory.title}} ({{memory.info}}%)</h6>
      <a-progress class="bar" :percent="memory.info" :show-info="false" size="small" :strokeWidth="4"/>
    </a-col>
  </a-row>
</template>

<script>
export default {
  props: ['info']
}
</script>

<style scoped>
.memory .title{
  color:blue;
  margin-right: 6px;
}
.memory .bar{
  width: 100%;
  margin: -10px 0 -10px 0
}
h6{
  margin: 0;
}
.memory{
  line-height: 1;
}
</style>
