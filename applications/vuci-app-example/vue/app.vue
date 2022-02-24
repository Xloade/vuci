<template>
  <div class="example">
    <a-input v-model="time"></a-input>
    <a-button type="primary">{{$t("Examples")}}</a-button>
    this is test string
  </div>
</template>

<script>
export default {
  data () {
    return {
      time: ''
    }
  },
  methods: {
    get_time () {
      this.$rpc.call('dainius', 'get_tume', {}).then((r) => {
        this.time = r.time
      })
    }
  }
}
</script>
