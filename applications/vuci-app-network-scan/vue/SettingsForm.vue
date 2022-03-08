<template>
  <div>
    <h2>{{$t("settings.Network scan options")}}</h2>
    <a-row type="flex" justify="center">
      <a-col span="18">
        <a-form-model ref="form" :rules="rules" :model="form" :label-col="labelCol" :wrapper-col="wrapperCol">
          <a-form-model-item :label="$t('settings.Scan speed')">
            <a-select v-model="form.speed">
                <a-select-option value="-T0">
                {{$t("settings.speed.Very slow")}}
                </a-select-option>
                <a-select-option value="-T1">
                {{$t("settings.speed.Slow")}}
                </a-select-option>
                <a-select-option value="-T2">
                {{$t("settings.speed.Normal")}}
                </a-select-option>
                <a-select-option value="-T3">
                {{$t("settings.speed.Fast")}}
                </a-select-option>
                <a-select-option value="-T4">
                {{$t("settings.speed.Very fast")}}
                </a-select-option>
                <a-select-option value="-T5">
                {{$t("settings.speed.Agressive")}}
                </a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item :colon="false">
            <template #label>
              <div class="label-inner">
                <a-tooltip class="toolTip">
                  <template #title>
                    100 most common ports are scanned.
                    <a href="https://nmap.org/book/port-scanning.html#most-popular-ports" target="_blank">What Are the Most Popular Ports?</a>
                  </template>
                  <question-mark-svg style="fill: grey;"/>
                </a-tooltip>
                {{$t('settings.Common port scan')}} :
              </div>
            </template>
            <a-switch v-model="form.port_common_scan" :disabled="form.port_custom_scan"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('settings.Custom port scan')">
            <a-switch v-model="form.port_custom_scan" :disabled="form.port_common_scan"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('settings.Custom ports')" v-if="form.port_custom_scan">
              <a-table :columns="portColumns" :data-source="form.ports" :rowKey="(a) => a.portIndex.toString()">
                <a-form-model-item :prop="`ports[${index}].port`" :rules="rules.port" slot="portForm" slot-scope="text, record, index">
                  <a-input :placeholder="$t('settings.Please enter', {lable:$t('port')})" v-model="form.ports[index].port"/>
                </a-form-model-item>
                <a-form-model-item :prop="`ports[${index}].discription`" slot="discriptionForm" slot-scope="text, record, index">
                  <a-input :placeholder="$t('settings.Please enter', {lable:$t('settings.Port usage')})" v-model="form.ports[index].discription"/>
                </a-form-model-item>
                  <a-button type="danger"  slot="operation" slot-scope="text, record, index" @click="form.ports.splice(index, 1)">{{$t('Delete')}}</a-button>
              </a-table>
              <a-button type="primary" @click="addPort">{{$t('Add')}}</a-button>
          </a-form-model-item>
          <a-form-model-item :label="$t('settings.Custom subnet scan')">
            <a-switch v-model="form.subnet_custom_scan"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('settings.Custom subnet')" v-if="form.subnet_custom_scan" prop="subnet">
            <a-input-group>
              <a-input v-model="form.subnet.ip" style="width: 130px" :placeholder="$t('ip')"/>
              <a-input
                style=" width: 30px; border-left: 0; pointer-events: none; backgroundColor: #fff"
                placeholder="/"
                disabled
              />
              <a-input v-model="form.subnet.mask" style="width: 75px" :placeholder="$t('mask')"/>
            </a-input-group>
          </a-form-model-item>
        </a-form-model>
      </a-col>
    </a-row>
  </div>
</template>
<script>
import QuestionMarkSvg from './QuestionMarkSvg.vue'
export default {
  data () {
    return {
      portColumns: [
        {
          dataIndex: 'port',
          title: this.$t('Port'),
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
      rules: {
        subnet: [
          { transform: () => this.form.subnet.ip, required: true, message: this.$t('settings.Please enter', { lable: this.$t('ip') }), trigger: 'change' },
          { transform: () => this.form.subnet.ip, pattern: '((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)(\\.(?!$)|$)){4}', message: this.$t('settings.Must be valid', { lable: this.$t('ip') }), trigger: 'change' },
          { transform: () => this.form.subnet.mask, required: true, message: this.$t('settings.Please enter', { lable: this.$t('mask') }), trigger: 'change' },
          { transform: () => parseInt(this.form.subnet.mask), type: 'integer', min: 1, max: 31, message: this.$t('settings.Must be valid', { lable: this.$t('mask') }), trigger: 'change' }
        ],
        port: [
          { required: true, message: this.$t('settings.Please enter', { lable: this.$t('port') }), trigger: 'change' },
          { transform: (value) => parseInt(value), type: 'integer', min: 1, max: 65535, message: this.$t('settings.Must be valid', { lable: this.$t('port') }), trigger: 'change' }
        ]
      },
      portIndex: 0,
      labelCol: { span: 6 },
      wrapperCol: { span: 12 },
      form: {
        speed: '-T2',
        port_custom_scan: false,
        port_common_scan: false,
        ports: [],
        subnet_custom_scan: false,
        subnet: { ip: '', mask: '' }
      },
      formRef: null
    }
  },
  mounted () {
    this.formRef = this.$refs.form
  },
  methods: {
    addPort () {
      this.form.ports.push({ port: null, discription: '', portIndex: this.portIndex++ })
    }
  },
  components: {
    QuestionMarkSvg
  }
}
</script>

<style scoped>
  .toolTip{
    margin: auto 10px;
  }
  .label-inner{
    display: inline-flex;
    align-content: center;
  }
</style>
