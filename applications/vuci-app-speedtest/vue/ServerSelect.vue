<template>
    <div>
      <a-button type="primary" @click="showModal" block>
        Open server Select
        <template v-if="selected"> ({{selected.Provider}})</template>
      </a-button>
      <a-modal v-model="visible" title="Server select" on-ok="handleOk" centered :width="900">
        <template slot="footer">
          <a-button key="back" @click="handleCancel">
            Return
          </a-button>
        </template>
        <a-form-model :label-col="{span:2}" :wrapper-col="{span:14}">
          <a-form-model-item label="Search">
            <a-input v-model="searchVal" @blur="search()" @keypress.enter="search()" style="width: 250px"/>
            <a-button class="search-btn" @click="search()" type="primary">Search</a-button>
          </a-form-model-item>
        </a-form-model>
        <a-table :columns="columns" :data-source="list" rowKey="ID" :pagination="{defaultPageSize:7}">
          <span slot="action" slot-scope="text, record">
            <a-button type="primary" disabled v-if="record === selected">Selected</a-button>
            <a-button type="primary" @click="select(record)" v-else>Select</a-button>
          </span>
        </a-table>
      </a-modal>
    </div>
</template>

<script>
export default {
  props: ['list', 'selected'],
  data () {
    return {
      searchVal: '',
      loading: false,
      visible: false,
      filteredInfo: { Provider: [] }
    }
  },
  methods: {
    search () {
      if (this.search === '') {
        this.filteredInfo.Provider = []
      } else {
        this.filteredInfo.Provider = [this.searchVal]
      }
    },
    select (server) {
      this.$emit('select', server)
    },
    showModal () {
      this.visible = true
    },
    handleOk (e) {
      this.loading = true
      setTimeout(() => {
        this.visible = false
        this.loading = false
      }, 3000)
    },
    handleCancel (e) {
      this.visible = false
    }
  },
  computed: {
    columns () {
      const columns = [
        {
          width: '35%',
          title: 'Provider',
          dataIndex: 'Provider',
          key: 'Provider',
          filteredValue: this.filteredInfo.Provider || null,
          onFilter: (value, record) => record.Provider
            .toString()
            .toLowerCase()
            .includes(value.toLowerCase())
        },
        {
          width: '50%',
          title: 'Host',
          dataIndex: 'Host',
          key: 'Host'
        },
        {
          width: '25',
          title: 'Action',
          key: 'action',
          scopedSlots: { customRender: 'action' }
        }
      ]
      return columns
    }
  }
}
</script>

<style scoped>
  .search-btn{
    margin-left: 12px;
  }
</style>
