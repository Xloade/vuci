<template>
  <div class="example">
    <a-input v-model="time"></a-input>
    <a-button type="primary" @click="get_time">{{$t("Examples")}}</a-button>
  </div>
</template>

<script>
export default {
  data () {
    return {
      time: '',
      proto: ['dhpc', 'static'],
      columns: [
        { name: 'address', label: 'IP address changed' },
        { name: 'netmask', label: 'Netmask changed' }
      ]
    }
  },
  methods: {
    get_time () {
      this.$rpc.call('dainiaus', 'get_net_hosts', {}).then((r) => {
        this.time = r.hosts
      })
    }
  }
}
</script>
