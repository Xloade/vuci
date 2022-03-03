<template>
  <div>
    <h2>{{$t("settings.Network scan options")}}</h2>
    <a-form-model :model="form" :label-col="labelCol" :wrapper-col="wrapperCol">
      <a-form-model-item :label="$t('settings.Scan speed')">
        <a-radio-group v-model="form.speed">
            <a-radio-button value="-T0">
            {{$t("settings.speed.Very slow")}}
            </a-radio-button>
            <a-radio-button value="-T1">
            {{$t("settings.speed.Slow")}}
            </a-radio-button>
            <a-radio-button value="-T2">
            {{$t("settings.speed.Normal")}}
            </a-radio-button>
            <a-radio-button value="-T3">
            {{$t("settings.speed.Fast")}}
            </a-radio-button>
            <a-radio-button value="-T4">
            {{$t("settings.speed.Very fast")}}
            </a-radio-button>
            <a-radio-button value="-T5">
            {{$t("settings.speed.Agressive")}}
            </a-radio-button>
        </a-radio-group>
      </a-form-model-item>
      <a-form-model-item :label="$t('settings.Common port scan')" >
        <a-switch v-model="form.port_common_scan" :disabled="form.port_custom_scan"/>
      </a-form-model-item>
      <a-form-model-item :label="$t('settings.Custom port scan')">
        <a-switch v-model="form.port_custom_scan" :disabled="form.port_common_scan"/>
      </a-form-model-item>
      <a-form-model-item :label="$t('settings.Custom ports')" v-show="form.port_custom_scan">
          <a-table :columns="portColumns" :data-source="form.ports" :rowKey="(a) => a.portIndex.toString()">
              <a-input slot="portForm" slot-scope="text, record, index" :placeholder="$t('settings.Please enter', {lable:$t('settings.Port')})" v-model="form.ports[index].port"/>
              <a-input slot="discriptionForm" slot-scope="text, record, index" :placeholder="$t('settings.Please enter', {lable:$t('settings.Port usage')})" v-model="form.ports[index].discription"/>
              <a-button type="danger"  slot="operation" slot-scope="text, record, index" @click="form.ports.splice(index, 1)">{{$t('Delete')}}</a-button>
          </a-table>
          <a-button type="primary" @click="addPort">{{$t('Add')}}</a-button>
      </a-form-model-item>
    </a-form-model>
  </div>
</template>
<script>

export default {
  data () {
    return {
      portColumns: [
        {
          dataIndex: 'port',
          title: this.$t('settings.Port'),
          scopedSlots: { customRender: 'portForm' }
        },
        {
          dataIndex: 'discription',
          title: this.$t('settings.Port usage'),
          scopedSlots: { customRender: 'discriptionForm' }
        },
        {
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' }
        }
      ],
      portIndex: 0,
      labelCol: { span: 4 },
      wrapperCol: { span: 14 },
      form: {
        speed: '-T2',
        port_custom_scan: false,
        port_common_scan: false,
        ports: []
      }
    }
  },
  methods: {
    addPort () {
      this.form.ports.push({ port: null, discription: null, portIndex: this.portIndex++ })
    }
  }
}
</script>
