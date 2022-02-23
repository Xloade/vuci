<template>
  <div class="example">
      <a-input v-model="time"></a-input>
      <a-button type="primary"></a-button>
  </div>
</template>

<script>
export default {
    data(){
        return{
            time:''
        }
    },
    methods: {
        get_time(){
            this.$rpc.call('example', 'get_tume', {})
            .then(r =>{
                this.time = r.time
            })
        }
    }

}
</script>

<style>

</style>