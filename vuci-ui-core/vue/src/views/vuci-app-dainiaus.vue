<template>
  <div class="example">
    <a-input v-model="time"></a-input>
    <a-button type="primary" @click="get_time">{{$t("Examples")}}</a-button>
    this is test string
    <vuci-form uci-config="example">
      <vuci-named-section name="example_sct" v-slot="{ s }" :card="false">
        <vuci-form-item-switch :uci-section="s" :label="'Enable'" name="enable" initial true-value="1" false-value="0" :help="'To enable example program'"/>
        <vuci-form-item-select :uci-section="s" :label="'Protocol'" name="proto" :options="proto" initial="static" required/>
        <vuci-form-item-input :uci-section="s" :label="'IP address'" name="address" placeholder="192.168.1.1." depend="proto == 'static'" rules="ipaddr"/>
      </vuci-named-section >
    </vuci-form>

    <vuci-form uci-config="example">
      <vuci-typed-section type="interface" addremove :columns="columns">
        <template #address="{ s }">
          <vuci-form-item-input :uci-section="s"  name="address" rules="ipaddr"/>
        </template>
        <template #netmask="{ s }">
          <vuci-form-item-input :uci-section="s"  name="netmask" rules="netmask4"/>
        </template>
      </vuci-typed-section>
    </vuci-form>
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
      this.$rpc.call('dainiaus', 'get_time', {}).then((r) => {
        this.time = r.time
      })
    }
  }
}
</script>
