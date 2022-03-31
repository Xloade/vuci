<template>
  <div>
    <a-modal v-model="visible" title="Show/Hide Cards" @ok="handleOk" @cancel="handleCancel" centered>
      <template slot="footer">
        <a-button key="submit" @click="handleOk">
          Done
        </a-button>
      </template>
      <a-form-model :label-col="{ span: 6 }" :wrapper-col="{ span: 14 }">
        <div v-for="card in cards" :key="card.name" >
          <a-form-model-item :label="$t(card.name)" v-if="card.name !== 'wan6Card'">
            <a-switch  v-model="card.info.show" @change="syncFiltered"/>
          </a-form-model-item>
        </div>
      </a-form-model>
    </a-modal>
    <a-button class="openModalBtn" type="primary" @click="showModal">
      Show/Hide Cards
    </a-button>
    <a-row :gutter="[12,12]" type="flex">
      <draggable class="drag" @change="saveOrder" :list="filteredCards" @start="drag=true" @end="drag=false" :animation="200" ghost-class="ghost-card">
        <a-col class="outer-card" :span="6" v-for="card in filteredCards" :key="card.name">
          <component :is="card.name"/>
        </a-col>
      </draggable>
    </a-row>
  </div>
</template>

<script>
import SystemCard from './SystemCard.vue'
import SystemLogCard from './SystemLogCard.vue'
import NetworkLogCard from './NetworkLogCard.vue'
import LanCard from './LANCard.vue'
import WanCard from './WANCard.vue'
import Wan6Card from './WAN6Card.vue'
import AccessCard from './AccessCard.vue'
import draggable from 'vuedraggable'
export default {
  data () {
    return {
      cards: [],
      filteredCards: [],
      visible: false
    }
  },
  methods: {
    syncFiltered () {
      this.cards.find(e => e.name === 'wan6Card').info.show = this.cards.find(e => e.name === 'wanCard').info.show
      this.filteredCards = this.filteredCards.map((e, i) => {
        e.info.order = i
      })
      this.filteredCards = this.cards.filter((e) => e.info.show).sort((a, b) => { return a.info.order - b.info.order })
    },
    saveShow () {
      this.$rpc.call('mainpage', 'SaveShow', { cards: this.cards })
    },
    saveOrder () {
      this.filteredCards = this.filteredCards.map((e, i) => {
        e.info.order = i
        return e
      })
      this.$rpc.call('mainpage', 'SaveOrder', { cards: this.filteredCards })
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
          this.syncFiltered()
        })
    },
    showModal () {
      this.visible = true
    },
    handleOk (e) {
      this.saveShow()
      this.visible = false
    },
    handleCancel (e) {
      this.saveShow()
    }
  },
  created () {
    this.get()
  },
  components: {
    SystemCard,
    SystemLogCard,
    NetworkLogCard,
    LanCard,
    WanCard,
    Wan6Card,
    AccessCard,
    draggable
  }
}
</script>

<style>
.outer-card{
  border: 1px solid #c2c2c200;
}
.ghost-card {
  opacity: 0.5;
  background: #F7FAFC;
  border: 1px solid #4299e1;
}
.openModalBtn{
  margin:12px
}
.drag{
  width: 100%;
}
</style>
