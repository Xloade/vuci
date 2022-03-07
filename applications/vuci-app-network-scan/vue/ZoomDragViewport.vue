<template lang="">
  <div class="viewport" ref="viewport" @mousedown="mouseDownHandler" @wheel.prevent="mouseWheelHandler">
    <div
      ref="elementArea" class="elementAreaOuter"
      :style="[{transform: `translate(${-scrollLeft}px, ${-scrollTop}px) scale(${zoom}`},{width:`${areaWidth+marginX}px`},{height:`${areaHeight+marginY}px`}]"
    >
    <div class="elementArea" :style="[{width:`${areaWidth}px`},{height:`${areaHeight}px`},{top:`${marginY/2}px`},{left:`${marginX/2}px`}]">
      <slot />
    </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['areaWidth', 'areaHeight'],
  data () {
    return {
      zoom: 1,
      pos: { top: 0, left: 0, x: 0, y: 0 },
      originY: this.areaHeight / 2,
      originX: this.areaWidth / 2,
      marginY: this.areaHeight,
      scrollTop: 0,
      scrollLeft: 0
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
        left: this.scrollLeft,
        top: this.scrollTop,
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
      this.scrollTop = this.pos.top - dy
      this.scrollLeft = this.pos.left - dx
    },
    mouseUpHandler () {
      this.$refs.viewport.style.cursor = 'grab'
      this.$refs.viewport.style.removeProperty('user-select')

      document.removeEventListener('mousemove', this.mouseMoveHandler)
      document.removeEventListener('mouseup', this.mouseUpHandler)
    },
    zoomToFit () {
      if (!isFinite(this.areaWidth)) return
      this.zoom = this.$refs.viewport.clientWidth / this.areaWidth
      if (this.zoom > 0.4) {
        this.zoom = 0.4
      }
      this.scrollTop = (this.areaHeight + this.marginY - this.$refs.viewport.clientHeight) / 2
      this.scrollLeft = (this.areaWidth + this.marginX - this.$refs.viewport.clientWidth) / 2
    }
  },
  computed: {
    marginX () {
      return this.areaWidth * 2
    }
  },
  watch: {
    areaWidth () {
      this.$nextTick(function () {
        this.zoomToFit()
      })
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
    cursor: grab;
    position: relative;
    overflow: hidden;
  }
  .elementAreaOuter{
    position: relative;
    z-index:1;
  }
  .elementArea{
    position: relative;
  }
</style>
