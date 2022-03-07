<template>
    <div class="overlay">
        <slot/>
    </div>
</template>

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
