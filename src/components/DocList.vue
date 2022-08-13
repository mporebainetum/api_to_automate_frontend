<template>

  <div v-if="!loading && data && data.length">
    <div v-for="doc of data">
      <DocItem>
        <template #heading>{{ doc._id["$oid"] }}</template>
        {{ doc.info }}
      </DocItem>
    </div>
  </div>

  <p v-if="!loading && data && data.length === 0">
    Create some docs in database to display them!
  </p>

  <p v-if="loading">
    Loading documents from db...
  </p>

  <p v-if="error">
    {{ error }}
  </p>
</template>

<script lang="js">
import { ref } from '@vue/reactivity'
import DocItem from './DocItem.vue'
import { onMounted } from '@vue/runtime-core';
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'DocList',
  components: {
    DocItem
  },
  props: {},
  setup() {
    const data = ref(null);
    const loading = ref(true);
    const error = ref(null);

    function fetchData() {
      loading.value = true;
      return fetch('/api/doc', {
        method: 'get',
        headers: {
          'content-type': 'application/json'
        }
      })
        .then(res => {
          if (!res.ok) {
            const error = new Error(res.statusText);
            error.json = res.json();
            throw error;
          }
          return res.json();
        })
        .then(json => {
          data.value = json;
        })
        .catch(err => {
          error.value = err;
          if (err.json) {
            return err.json.then(json => {
              error.value.message = json.message;
            });
          }
        })
        .then(() => {
          loading.value = false;
        });
    }

    onMounted(() => {
      fetchData();
    });
    return {
      data,
      loading,
      error
    };
  }
})
</script>
