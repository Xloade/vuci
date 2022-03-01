<template lang="">
  <div class="viewport" ref="viewport" @mousedown="mouseDownHandler" @wheel.prevent="mouseWheelHandler">
    <div v-if="showInner" ref="elementArea" class="elementArea"
    :style="[{transform: `scale(${zoom})`},{width:`${areaWidth}px`},{height:`${areaHeight}px`},{transformOrigin:`${originX}px ${originY}px`}]">
      <slot />
    </div>
  </div>
</template>
<script>
export default {
  props: ['showInner', 'areaWidth', 'areaHeight'],
  data () {
    return {
      zoom: 1,
      pos: { top: 0, left: 0, x: 0, y: 0 },
      originY: this.areaHeight / 2,
      originX: this.areaWidth / 2
    }
  },
  methods: {
    mouseWheelHandler (e) {
      // var x = ((((e.pageX - this.$refs.viewport.offsetLeft) + this.$refs.viewport.scrollLeft) - 3000) / this.zoom) + 3000
      // var y = ((((e.pageY - this.$refs.viewport.offsetTop) + this.$refs.viewport.scrollTop) - 3000) / this.zoom) + 3000
      if (event.deltaY < 0) {
        // Zoom in
        this.zoom *= event.deltaY * -0.01
      } else {
        // Zoom out
        this.zoom /= event.deltaY * 0.01
      }
      // this.$refs.viewport.scrollTop = y
      // this.originY = y
    },
    mouseDownHandler (e) {
      this.$refs.viewport.style.cursor = 'grabbing'
      this.$refs.viewport.style.userSelect = 'none'

      this.pos = {
        left: this.$refs.viewport.scrollLeft,
        top: this.$refs.viewport.scrollTop,
        // Get the current mouse position
        x: e.clientX,
        y: e.clientY
      }
      document.addEventListener('mousemove', this.mouseMoveHandler)
      document.addEventListener('mouseup', this.mouseUpHandler)
    },
    mouseMoveHandler (e) {
      const dx = e.clientX - this.pos.x
      const dy = e.clientY - this.pos.y

      // Scroll the element
      this.$refs.viewport.scrollTop = this.pos.top - dy
      this.$refs.viewport.scrollLeft = this.pos.left - dx
    },
    mouseUpHandler () {
      this.$refs.viewport.style.cursor = 'grab'
      this.$refs.viewport.style.removeProperty('user-select')

      document.removeEventListener('mousemove', this.mouseMoveHandler)
      document.removeEventListener('mouseup', this.mouseUpHandler)
    },
    zoomToFit () {
      this.zoom = this.$refs.viewport.clientWidth / this.areaWidth
      this.$refs.viewport.scrollTop = this.$refs.viewport.scrollTopMax / 2
      this.$refs.viewport.scrollLeft = this.$refs.viewport.scrollLeftMax / 2
    }
  },
  Watch: {
    areaWidth () {
      this.zoomToFit()
    }
  },
  mounted () {
    this.zoomToFit()
  }
}
</script>
<style scoped>
  .viewport{
    width: 100%;
    height: calc(100vh - 150px);
    background: #9b9696;
    overflow: auto;
    cursor: grab;
    position: relative;
  }
  .elementArea{
    z-index:1;
  }
</style>
