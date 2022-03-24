<template>
  <div>
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

</style>
