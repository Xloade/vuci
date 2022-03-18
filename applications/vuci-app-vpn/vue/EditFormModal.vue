<template>
  <div>
    <a-modal
      :title="'Edit '+form.name"
      :visible="visible"
      okText="Save"
      :cancelButtonProps="{props: {type:'danger'}}"
      @ok="handleCreate"
      @cancel="handleCancel"
      :width=750
      :bodyStyle="{display:'flex'}"
      centered
    >
      <a-form-model class="form" ref="form" :rules="rules" :model="form" :label-col="labelCol" :wrapper-col="wrapperCol">
        <a-form-model-item :label="$t('editForm.isEnabled')">
          <a-switch v-model="form.isEnabled"/>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.auth')" prop="auth" :rules="rules.required">
          <a-select v-model="form.auth" style="width: 250px">
            <a-select-option value="skey">
              {{$t("editForm.skey")}}
            </a-select-option>
            <a-select-option value="tls">
              {{$t("editForm.tls")}}
            </a-select-option>
          </a-select>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.port')" prop="port">
          <a-input v-model="form.port" style="width: 250px"/>
        </a-form-model-item>
        <div v-if="form.type == 'client'" >
          <a-form-model-item :label="$t('editForm.remote')" prop="remote" :rules="[...rules.required,...rules.ip, ...rules.ipNotEqualToLan]">
            <a-input v-model="form.remote" style="width: 250px"/>
          </a-form-model-item>
        </div>
        <div v-if="form.auth == 'skey'">
          <a-form-model-item :label="$t('editForm.localIp')" prop="localIp" :rules="rules.ip">
            <a-input v-model="form.localIp" style="width: 250px"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.remoteIp')" prop="remoteIp" :rules="rules.ip">
            <a-input v-model="form.remoteIp" style="width: 250px"/>
          </a-form-model-item>
        </div>
        <div v-if="!(form.type == 'server' && form.auth == 'tls')">
          <a-form-model-item :label="$t('editForm.network.ip')" prop="network.ip" :rules="[...rules.ip, ...rules.ipEqualToMask]">
            <a-input v-model="form.network.ip" style="width: 250px"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.network.mask')" prop="network.mask" :rules="rules.mask">
            <a-input v-model="form.network.mask" style="width: 250px" @blur="$refs.form.validateField('network.ip')"/>
          </a-form-model-item>
        </div>
        <div v-if="form.type == 'server' && form.auth == 'tls'" >
          <a-form-model-item :label="$t('editForm.server.ip')"  prop="server.ip" :rules="[...rules.required,...rules.ip]">
            <a-input v-model="form.server.ip" style="width: 250px"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.server.mask')"  prop="server.mask" :rules="[...rules.required,...rules.mask]">
            <a-input v-model="form.server.mask" style="width: 250px"/>
          </a-form-model-item>
        </div>
        <div v-if="form.type == 'server' && form.auth == 'tls'" >
          <a-form-model-item :label="$t('editForm.certs.dh')"  prop="dh" :rules="rules.fileUpload">
            <a-upload
              :file-list="form.dh" @change="(e) => handleChange(form.dh, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.dh.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
        </div>
        <div v-if="form.auth == 'tls'">
          <a-form-model-item :label="$t('editForm.certs.ca')" prop="ca" :rules="rules.fileUpload">
            <a-upload
              :file-list="form.ca" @change="(e) => handleChange(form.ca, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.ca.cert.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.certs.'+form.type)+' '+$t('editForm.certs.cert')" prop="cert" :rules="rules.fileUpload">
              <a-upload
                :file-list="form.cert" @change="(e) => handleChange(form.cert, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.cert.pem'}">
                <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
              </a-upload>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.certs.'+form.type)+' '+$t('editForm.certs.key')" prop="key" :rules="rules.fileUpload">
            <a-upload
              :file-list="form.key" @change="(e) => handleChange(form.key, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.key.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
        </div>
        <div v-if="form.auth == 'skey'">
          <a-form-model-item :label="$t('editForm.secret')" prop="secret" :rules="rules.fileUpload">
            <a-upload
              :file-list="form.secret" @change="(e) => handleChange(form.secret, e)" accept=".key" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.secretstatic.key'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
        </div>
      </a-form-model>
    </a-modal>
  </div>
</template>
<script>
import VuciValidator from '@/plugins/vuci-validator'
import IpValidator from './ip-validator'

const form = {
  isEnabled: true,
  auth: '',
  name: '',
  server: {
    ip: '',
    mask: ''
  },
  ca: [],
  cert: [],
  key: [],
  dh: [],
  type: '',
  remote: '',
  network: {
    ip: '',
    mask: ''
  },
  localIp: '',
  remoteIp: '',
  secret: [],
  port: ''
}

export default {
  data () {
    return {
      lan: null,
      visible: false,
      labelCol: { span: 12 },
      wrapperCol: { span: 12 },
      form,
      rules: {
        required: [
          { required: true, message: this.$t('invalid.required'), trigger: 'blur' }
        ],
        ipEqualToMask: [
          {
            validator: (rule, value, callback) => {
              if (value === '' || value === undefined) callback()
              else if (!IpValidator.isEqualMask(value, form.network.mask)) callback(new Error(this.$t('invalid.ip/mask missmatch')))
              else callback()
            },
            trigger: 'blur'
          }
        ],
        ipNotEqualToLan: [
          {
            validator: (rule, value, callback) => {
              if (value === this.lan) callback(new Error(this.$t('invalid.ip/mask missmatch')))
              else callback()
            },
            trigger: 'blur'
          }
        ],
        ip: [
          {
            validator: (rule, value, callback) => {
              if (value === '' || value === undefined) callback()
              else if (!VuciValidator.ip4addr(value)) callback(new Error(this.$t('invalid.ip')))
              else callback()
            },
            trigger: 'blur'
          }
        ],
        mask: [
          {
            validator: (rule, value, callback) => {
              if (value === '' || value === undefined) callback()
              else if (!VuciValidator.netmask4(value)) callback(new Error(this.$t('invalid.mask')))
              else callback()
            },
            trigger: 'blur'
          }
        ],
        port: [
          {
            validator: (rule, value, callback) => {
              if (value === '' || value === undefined) callback()
              else if (!VuciValidator.port(value)) callback(new Error(this.$t('invalid.port')))
              else callback()
            },
            trigger: 'blur'
          }
        ],
        fileUpload: [
          { required: true, message: this.$t('invalid.file required'), trigger: 'change' }
        ]
      }
    }
  },
  methods: {
    showModal (name) {
      this.form.name = name
      this.getVPN()
      this.visible = true
    },
    handleCreate (e) {
      this.$refs.form.validate(valid => {
        if (valid) {
          // prevent undefined as cleared forms can have it and we sometimes want send empty network settings
          this.form.network.ip = this.form.network.ip || ''
          this.form.network.mask = this.form.network.mask || ''
          this.$rpc.call('vpn', 'edit', { form: this.form })
            .then(this.$uci.apply())
            .then(this.$system.initRestart('openvpn'))
            .then((r) => {
              this.$refs.form.resetFields()
              this.$emit('edited')
              this.visible = false
            })
        }
      })
    },
    handleCancel (e) {
      this.visible = false
      this.$refs.form.resetFields()
    },
    getVPN () {
      this.$rpc.call('vpn', 'getVpn', { name: this.form.name }).then((r) => {
        const vpn = r.vpn
        const form = this.form
        form.type = vpn.type
        form.isEnabled = vpn.enable
        form.auth = vpn._auth
        form.port = vpn.port
        if (!(vpn.type === 'server' && vpn._auth === 'tls')) {
          form.network.ip = vpn.network_ip
          form.network.mask = vpn.network_mask
        }
        if (vpn.type === 'server') {

        } else if (form.type === 'client') {
          form.remote = vpn.remote
        }
        if (vpn._auth === 'tls') {
          form.ca = vpn.ca !== '' ? [{ uid: '-1', name: vpn.ca, status: 'done' }] : []
          form.cert = vpn.cert !== '' ? [{ uid: '-1', name: vpn.cert, status: 'done' }] : []
          form.key = vpn.key !== '' ? [{ uid: '-1', name: vpn.key, status: 'done' }] : []
          if (vpn.type === 'server') {
            form.dh = vpn.dh !== '' ? [{ uid: '-1', name: vpn.dh, status: 'done' }] : []
            form.server.ip = vpn.server_ip
            form.server.mask = vpn.server_netmask
          } else if (form.type === 'client') {

          }
        } else if (vpn._auth === 'skey') {
          form.secret = vpn.secret !== '' ? [{ uid: '-1', name: vpn.secret, status: 'done' }] : []
          form.localIp = vpn.local_ip
          form.remoteIp = vpn.remote_ip
        }
      })
    },
    handleChange (usedFileList, info) {
      const fileList = [...info.fileList]
      // use only first file
      usedFileList.splice(0, usedFileList.length)
      if (fileList.length > 0) {
        usedFileList.push(fileList[fileList.length - 1])
      }
    }
  },
  created () {
    this.$network.load()
      .then(() => {
        this.lan = this.$network.getInterface('lan').getIPv4Addrs()[0]
      })
  }
}
</script>

<style scoped>
.form{
  margin:auto;
}
</style>
