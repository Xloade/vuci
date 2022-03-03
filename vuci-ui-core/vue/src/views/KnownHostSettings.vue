<template>
  <div>
    <h2>{{$t("settings.Known hosts")}}</h2>
    <vuci-form uci-config="vuci-app-network-scan" ref="settingForm">
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
      knownHostsColumns: [
        { name: 'macAddr', label: this.$t('settings.Mac adress') },
        { name: 'description', label: this.$t('settings.Host name') }
      ]
    }
  }
}
</script>
