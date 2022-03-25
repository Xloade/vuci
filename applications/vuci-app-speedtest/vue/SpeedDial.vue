<template>
  <div>
    <p
      class="speed-num"
      v-for="(value, index) in Array(11)"
      :key="index"
      :style="{top: `${circle(40, 320, index, 11, 265, 165, 160).y}px`, left: `${circle(40, 320, index, 11, 265, 165, 160).x}px`}"
    >
      {{index*10}}
    </p>
    <a-progress
      stroke-linecap="square"
      :width="350"
      :percent="currentSpeed" type="dashboard"
      :stroke-color="currentColor"
    >
      <template #format>
        <h2>{{ currentSpeed.toFixed(2) }} Mbps</h2>
      </template>
    </a-progress>

  </div>
</template>

<script>
export default {
  props: ['DownResults', 'UpResults'],
  data () {
    return {
      gradiantDown: {
        '100%': '#0073d8',
        '0%': '#c90009'
      },
      gradiantUp: {
        '100%': '#A1D700',
        '0%': '#c90009'
      }
    }
  },
  methods: {
    circle (startDeg, finishDeg, index, listLenght, circleDiameter, offsetX, offseY) {
      const circleLenght = finishDeg - startDeg
      const currPos = 360 - (circleLenght / (listLenght - 1) * index + startDeg)
      const currPosRad = currPos * (Math.PI / 180)
      const x = (Math.sin(currPosRad) * circleDiameter / 2) + offsetX
      const y = (Math.cos(currPosRad) * circleDiameter / 2) + offseY
      return { x, y }
    }
  },
  computed: {
    currentColor () {
      return this.UpResults.length === 0 ? this.gradiantDown : this.gradiantUp
    },
    currentSpeed () {
      if (this.UpResults.length > 0) {
        return this.UpResults[this.UpResults.length - 1]
      }
      if (this.DownResults.length > 0) {
        return this.DownResults[this.DownResults.length - 1]
      }
      return 0
    }
  }
}
</script>

<style scoped>
  .speed-num{
    position: absolute;
  }
</style>
