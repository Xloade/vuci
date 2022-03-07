<template>
  <div>
    <h1>{{$t("In progress")}}</h1>
    <div class="subnet" v-for="subnet in progress" :key="subnet.discription">
      <h1>{{subnet.discription}}:</h1>
      <div class="progress-border">
        <a-progress :percent="subnet.progress.done? 100:parseFloat(subnet.progress.donePct)" :status="subnet.progress.done ? 'success': 'active'" />
      </div>
      <p v-if="!subnet.progress.done">{{$t("estimated/remaining", {elapsed:subnet.progress.timeElapsed, remaining:subnet.progress.remainingTime})}}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: ['progress']
}
</script>

<style scoped>
  .subnet{
    min-width: 300px;
  }
</style>
