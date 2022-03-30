<template>
  <div>
    <a-card size="small" :title="title" style="width: 300px">
        <slot />
    </a-card>
  </div>
</template>

<script>
export default {
  props: ['title']
}
</script>

<style lang="scss" scoped>

</style>
