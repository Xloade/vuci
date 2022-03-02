<template>
    <div>
        <vuci-form uci-config="vuci-app-network-scan" ref="settingForm">
            <vuci-named-section name="nmap" v-slot="{ s }" :card="false">
                <vuci-form-item-select :uci-section="s" :label="'Scan speed'" name="speed" :options="speed" initial="static" required/>
                <vuci-form-item-switch :uci-section="s" :label="'Enable port scan'" name="port_scan" initial true-value="1" false-value="0"/>
                <vuci-form-item-switch :uci-section="s" :label="'Enable common port scan'" name="port_common_scan" initial true-value="1" false-value="0" depend="port_scan == '1'"/>
                <vuci-form-item-switch :uci-section="s" :label="'Enable custom port scan'" name="port_custom_scan" initial true-value="1" false-value="0" depend="port_scan == '1'"/>
            </vuci-named-section >
            <h2>{{$t("settings.Custom ports")}}</h2>
            <vuci-typed-section type="custom_ports" addremove :columns="portColumns">
                <template #port="{ s }">
                    <vuci-form-item-input :uci-section="s"  name="port" rules="port"/>
                </template>
                <template #usage="{ s }">
                    <vuci-form-item-input :uci-section="s"  name="usage"/>
                </template>
            </vuci-typed-section>
            <h2>{{$t("settings.Known hosts")}}</h2>
            <vuci-typed-section type="known_hosts" addremove :columns="knownHostsColumns">
                <template #macAddr="{ s }">
                    <vuci-form-item-input :uci-section="s"  name="macAddr" rules="macaddr"/>
                </template>
                <template #description="{ s }">
                    <vuci-form-item-input :uci-section="s"  name="description"/>
                </template>
            </vuci-typed-section>
        </vuci-form>
    </div>
</template>

<script>
export default {
  data () {
    return {
      speed: ['-T0', '-T1', '-T2', '-T3', '-T4', '-T5'],
      portColumns: [
        { name: 'port', label: 'Port' },
        { name: 'usage', label: 'Port usage' }
      ],
      knownHostsColumns: [
        { name: 'macAddr', label: 'Mac adress' },
        { name: 'description', label: 'Host name' }
      ]
    }
  },
  methods: {
    apply () {
      this.$refs.settingForm.apply()
    }
  }
}
//  :show="$refs.port_custom_scan.value=='1'"
</script>

<style scoped>

</style>
