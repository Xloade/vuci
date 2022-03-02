<template>
    <div class="overlay">
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
    .overlay{
        position: absolute;
        top:0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(175,175,175,0.80);
        z-index: 100;

        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column
    }
</style>
