<template>
  <div>
    <a-modal v-model="visible" title="Show/Hide Information" @ok="handleOk" @cancel="handleCancel" centered>
      <template slot="footer">
        <a-button key="submit" @click="handleOk">
          Done
        </a-button>
      </template>
      <a-form-model :label-col="{ span: 6 }" :wrapper-col="{ span: 14 }">
        <a-form-model-item v-for="card in cards" :key="card.name" :label="card.name">
          <a-switch  v-model="card.info.show"/>
        </a-form-model-item>
      </a-form-model>
    </a-modal>
    <a-button class="openModalBtn" type="primary" @click="showModal">
      Show/Hide Information
    </a-button>
    <a-row :gutter="[12,12]" type="flex">
      <draggable @change="save" v-model="cards" @start="drag=true" @end="drag=false" :animation="200" ghost-class="ghost-card">
        <a-col class="card" :span="8" v-for="card in cards" :key="card.name">
          <component v-if="card.info.show" :is="card.name"/>
        </a-col>
      </draggable>
    </a-row>
  </div>
</template>

<script>
import SystemCard from './SystemCard.vue'
import LoggingCard from './LoggingCard.vue'
import LanCard from './LANCard.vue'
import draggable from 'vuedraggable'
export default {
  data () {
    return {
      cards: [],
      visible: false
    }
  },
  methods: {
    save () {
      this.cards = this.cards.map((e, i) => {
        e.info.order = i
        return e
      })
      this.$rpc.call('mainpage', 'Save', { cards: this.cards })
    },
    get () {
      this.$rpc.call('mainpage', 'Get', {})
        .then(r => {
          this.cards = r.cards.map(e => {
            return {
              name: e['.name'],
              info: {
                order: Number(e.order),
                show: e.show === '1'
              }
            }
          })
            .sort((a, b) => {
              return a.info.order - b.info.order
            })
        })
    },
    showModal () {
      this.visible = true
    },
    handleOk (e) {
      this.save()
      this.visible = false
    },
    handleCancel (e) {
      this.save()
    }
  },
  created () {
    this.get()
  },
  components: {
    SystemCard,
    LoggingCard,
    LanCard,
    draggable
  }
}
</script>

<style>
.card{
  border: 1px solid #4299e100;
}
.ghost-card {
  opacity: 0.5;
  background: #F7FAFC;
  border: 1px solid #4299e1;
}
.openModalBtn{
  margin:12px
}
</style>
