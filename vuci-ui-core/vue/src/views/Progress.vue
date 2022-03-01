<template>
    <div class="overlay">
        <h1>{{$t("In progress")}}</h1>
        <div class="subnet" v-for="subnet in progress" :key="subnet.discription">
            <h1>{{subnet.discription}}:</h1>
            <div class="progress-border">
                <div class="progress-precent"><div>{{subnet.progress.done ? $t("done"): subnet.progress.donePct}}</div></div>
                <div class="progress-bar" :style="{width:`${subnet.progress.done ? '100%': subnet.progress.donePct}`}"></div>
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
    .progress-border{
        border: 1p;
        width: 300px;
        height: 50px;
        background: lightgrey;
        position: relative;
        border-radius: 4px;
    }
    .progress-precent{
        position: absolute;
        top: 0px;
        left: 0px;
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .progress-bar{
        background: green;
        height: 100%;
        border-radius: 4px;
    }
</style>
