<template>
  <ValidationObserver v-slot="{ invalid }" slim>
    <v-container class="module-default__container">
      <div class="module-default__instructions">
        <v-expansion-panels v-model="showInstructions" class="module-default__instructions" flat>
          <v-expansion-panel>
            <v-expansion-panel-header
              v-show="showInstructions"
              hide-actions
              class="pa-0"
              @click="showInstructions = true"
            >
              <template v-slot="{ open }">
                <v-scroll-y-transition hide-on-leave>
                  <div v-if="!open" class="d-flex flex-column justify-center">
                    <v-icon color="grey lighten-2" class="d-flex justify-center">
                      mdi-chevron-down
                    </v-icon>
                    <div color="grey lighten-2" class="module-default__collapse-title">
                      INSTRUCTIONS
                    </div>
                  </div>
                </v-scroll-y-transition>
              </template>
            </v-expansion-panel-header>
            <v-expansion-panel-content>
              <Instruct readonly />
              <div @click="showInstructions = true">
                <div class="module-default__collapse-title">CLOSE</div>
                <!-- <div class="hr"/> OPTIONAL -->
                <v-icon color="grey lighten-2" class="d-flex justify-center">
                  mdi-chevron-up
                </v-icon>
              </div>
            </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>
      </div>
      <v-progress-linear
        class="module-default__collapse-divider"
        color="#dedede"
        height="2"
        value="100"
        buffer-value="100"
        stream
      />
      <div class="module-edit__container">
        <div class="module-default__row mb-10">
          <v-menu open-on-hover offset-y>
            <template v-slot:activator="{ on, attrs }">
              <v-btn v-bind="attrs" small dark color="blue" depressed v-on="on"
                ><v-icon left>mdi-form-select</v-icon>Final Draft</v-btn
              >
            </template>
            <v-card class="module__menu">
              <v-btn
                small
                color="white"
                class="module__chat-menu-button v-btn__content"
                tile
                depressed
              >
                <v-icon left color="#404142">mdi-form-select</v-icon>4th Draft</v-btn
              >
              <v-divider></v-divider>
              <v-btn
                small
                color="white"
                class="module__chat-menu-button v-btn__content"
                tile
                depressed
              >
                <v-icon left color="#404142">mdi-form-select</v-icon>3rd Draft</v-btn
              >
              <v-divider></v-divider>
              <v-btn
                small
                color="white"
                class="module__chat-menu-button v-btn__content"
                tile
                depressed
              >
                <v-icon left color="#404142">mdi-form-select</v-icon>2nd Draft</v-btn
              >

              <v-divider></v-divider>
              <v-btn
                small
                color="white"
                class="module__chat-menu-button v-btn__content"
                tile
                depressed
              >
                <v-icon left color="#404142">mdi-form-select</v-icon>1st Draft</v-btn
              >
            </v-card>
          </v-menu>
        </div>
        <validation-provider v-slot="{ errors }" slim rules="max:144">
          <v-textarea
            v-model="onePitch"
            :error-messages="errors"
            placeholder="Describe your solution in one sentence"
            prepend-inner-icon="mdi-text-short"
            class="module-default__textarea"
            outlined
            rows="3"
            row-height="30"
            label="One Sentence Pitch"
          ></v-textarea>
        </validation-provider>

        <br />
        <validation-provider v-slot="{ errors }" slim rules="required">
          <v-textarea
            v-model="elevatorPitch"
            :error-messages="errors"
            placeholder="Write your sixty second elevator pitch"
            prepend-inner-icon="mdi-text-subject"
            class="module-default__textarea"
            outlined
            rows="7"
            row-height="70"
            label="Elevator Pitch"
          ></v-textarea>
        </validation-provider>
        <br />
        <div class="module-default__row">
          <div><v-btn x-large outlined depressed>Save Draft</v-btn></div>
          <div class="ml-auto">
            <v-btn x-large color="blue" :disabled="invalid" dark depressed>Make Final Draft</v-btn>
          </div>
          <!-- <div><v-btn small disabled depressed>Current Version</v-btn></div>
        <div><v-btn small outlined depressed>Version 4</v-btn></div>
        <div><v-btn small outlined depressed>Version 3</v-btn></div>
        <div><v-btn small outlined depressed>Version 2</v-btn></div>
        <div><v-btn small outlined depressed>Version 1</v-btn></div> -->
        </div>
        <!-- ENTER CONTENT HERE -->
        <!-- DESIGN YOUR ACTIVITY HERE / COMMENT OUT WHEN YOU'VE STARTED DESIGNING -->
        <!-- <div class="module-default__none">Design your activity here</div> -->
      </div>
    </v-container>
  </ValidationObserver>
</template>

<script lang="ts">
import { ref } from '@vue/composition-api';
import Instruct from './ModuleInstruct.vue';

export default {
  name: 'ModuleDefault',
  components: {
    Instruct
  },
  apollo: {},
  setup() {
    const onePitch = ref();
    const elevatorPitch = ref();
    const setupInstructions = ref({
      description: '',
      instructions: ['', '', '']
    });
    const showInstructions = ref(true);
    return {
      setupInstructions,
      showInstructions,
      elevatorPitch,
      onePitch
    };
  }
};
</script>

<style lang="scss">
.module-default {
  &__row {
    flex-direction: row;
    display: flex;
  }

  &__textarea {
    // width: 100%;
  }
  &__none {
    border-radius: 5px;
    // border: 1px solid #dedede;
    height: 100px;
    text-align: center;
    background-color: #dedede;
    font-weight: 700;
    color: #ffffff;
    font-size: 18px;
    padding-top: 35px;
  }

  &__collapse-divider {
    margin-top: 15px;
    margin-bottom: 75px;
    margin-right: none;
    margin-left: none;
    padding-right: none;
    padding-left: none;
    width: 100%;
  }

  &__collapse-title {
    color: #dedede;
    text-align: center;
    text-transform: uppercase;
    font-weight: 900;
    letter-spacing: 1px;
    font-size: 13px;
    //  text-uppercase font-weight-bold text-subtitle-2 text-center
  }

  &__container {
    // width: 100%;
    // padding: none;
    // margin: none;
    margin-top: 0px;
    padding: 0px;
  }
  &__employer-title {
    font-size: 25px;
    font-weight: 700;
  }

  &__scope {
    font-size: 22px;
    font-weight: 800;
    text-align: center;
    max-width: 95%;
    margin: auto;
  }
  &__youtube {
    height: 400px;
    width: 95%;
    border-radius: 25px;
    // margin: 0px;
    background-color: #dedede;

    // text-align: center;
    // justify-content: center;
    // align-items: center;
    // padding-top: auto;
    // padding-bottom: auto;
  }
  &__about {
    font-size: 15px;
    font-weight: 700;
    text-align: center;
    max-width: 90%;
    margin: auto;
    line-height: 30px;
  }

  &__faq {
    font-size: 15px;
    font-weight: 700;
    text-align: center;
    max-width: 90%;
    margin: auto;
    line-height: 30px;
  }

  &__faq-chat {
    display: flex;
    flex-direction: column;
    text-align: left;
    margin-bottom: 5%;
  }
  &__faq-chat-line {
    margin: 5px;
  }

  &__faq-avatar {
    margin: 5px;
  }

  &__faq-question {
    // text-align: left;
    font-family: 'Raleway';
    font-size: 16px;
    font-weight: 800;
    color: #404142;
  }

  &__faq-answer {
    text-align: left;
    font-family: 'Raleway';
    font-size: 13px;
    font-weight: 500;
    letter-spacing: 0px;
    color: white;
    font-style: italic;
  }

  &__faq-answer-dark {
    text-align: left;
    font-family: 'Raleway';
    font-size: 13px;
    font-weight: 500;
    letter-spacing: 0px;
    color: #404142;
    font-style: italic;
  }

  &__faq-answer-dark-highlight {
    text-align: left;
    font-family: 'Raleway';
    font-size: 13px;
    font-weight: 800;
    letter-spacing: 0px;
    color: #404142;
  }

  &__specs-title {
    font-weight: 800;
  }
}
</style>
