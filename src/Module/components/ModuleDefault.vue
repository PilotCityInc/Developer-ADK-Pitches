<template>
  <ValidationObserver v-slot="{ invalid }" slim>
    <div>
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
        class="mt-3"
        color="#dedede"
        height="2"
        value="100"
        buffer-value="100"
        stream
      />
      <div class="pa-6">
        <div class="module-default__row mb-10">
          <v-menu open-on-hover offset-y>
            <template v-slot:activator="{ on, attrs }">
              <v-btn rounded v-bind="attrs" dark color="blue" depressed v-on="on"
                ><v-icon left>mdi-form-select</v-icon>
                {{ finalDraftSaved + ' #' + display }}
              </v-btn>
            </template>
            <v-card v-for="draft in adkData.vlaueDrafts.length" :key="draft" class="module__menu">
              <v-btn
                v-if="draft > 1"
                small
                color="white"
                class="module__chat-menu-button v-btn__content"
                tile
                depressed
                @click="showDraft(draft)"
              >
                <v-icon left color="#404142"> mdi-form-select </v-icon>
                Draft #{{ adkData.vlaueDrafts.length + 1 - draft }}
              </v-btn>
              <!-- <v-divider></v-divider>
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
              > -->
            </v-card>
          </v-menu>
        </div>
        <validation-provider v-slot="{ errors }" slim rules="required">
          <v-textarea
            v-model="adkData.vlaueDrafts[IndexVal].onePitch"
            rounded
            auto-grow
            :error-messages="errors"
            placeholder="Describe your solution in one sentence"
            prepend-inner-icon="mdi-text-short"
            class="module-default__textarea"
            outlined
            rows="3"
            row-height="30"
            maxlength="144"
            counter="144"
            label="One Sentence Pitch"
          ></v-textarea>
        </validation-provider>

        <br />
        <validation-provider v-slot="{ errors }" slim rules="required">
          <v-textarea
            v-model="adkData.vlaueDrafts[IndexVal].elevatorPitch"
            rounded
            :error-messages="errors"
            placeholder="Write your sixty second elevator pitch"
            prepend-inner-icon="mdi-text-subject"
            class="module-default__textarea"
            outlined
            rows="7"
            row-height="70"
            maxlength="500"
            counter="500"
            label="Elevator Pitch"
          ></v-textarea>
        </validation-provider>
        <br />
        <div class="module-default__row">
          <div>
            <v-btn rounded x-large outlined depressed @click="draftSave">Save Draft</v-btn>
          </div>
          <!-- <v-alert
            v-if="draftSave"
            type="success"
            dismissible
            border="left"
            close-text="Close Alert"
          >
            Draft saved!
          </v-alert> -->
          <div class="ml-auto">
            <v-btn
              :disabled="invalid"
              x-large
              rounded
              color="blue"
              dark
              depressed
              @click="finalDraft"
            >
              Make Final Draft
            </v-btn>
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
    </div>
  </ValidationObserver>
</template>

<script lang="ts">
import { defineComponent, PropType, ref } from '@vue/composition-api';
import { getModAdk, getModMongoDoc } from 'pcv4lib/src';
import Swal from 'sweetalert2';
import Instruct from './ModuleInstruct.vue';
import MongoDoc from '../types';

export default defineComponent({
  name: 'ModuleDefault',
  components: {
    Instruct
  },
  props: {
    value: {
      required: true,
      type: Object as PropType<MongoDoc>
    },
    studentDoc: {
      required: true,
      type: Object as PropType<MongoDoc | null>,
      default: () => {}
    }
  },
  setup(props, ctx) {
    const studentDocument = getModMongoDoc(props, ctx.emit, {}, 'studentDoc', 'inputStudentDoc');

    const initPitchesDefault = {
      vlaueDrafts: [
        {
          onePitch: '',
          elevatorPitch: '',
          finalDraft: false,
          draftIndex: '0'
          // draftIndex: ''
        }
      ]
    };

    const { adkData, adkIndex } = getModAdk(
      props,
      ctx.emit,
      'Pitches',
      initPitchesDefault,
      'studentDoc',
      'inputStudentDoc'
    );

    const IndexVal = ref(adkData.value.vlaueDrafts.length - 1);
    const display = ref(IndexVal.value);
    const finalDraftSaved = ref('Draft');

    function draftSave() {
      const draftNum = adkData.value.vlaueDrafts.length - 1;
      const draft = ref({
        onePitch: adkData.value.vlaueDrafts[IndexVal.value].onePitch,
        elevatorPitch: adkData.value.vlaueDrafts[IndexVal.value].elevatorPitch,
        finalDraft: false,
        draftIndex: IndexVal.value + 1
        // index: ''
      });
      if (
        adkData.value.vlaueDrafts[IndexVal.value].onePitch.length !== 0 ||
        adkData.value.vlaueDrafts[IndexVal.value].elevatorPitch.length !== 0
      ) {
        if (adkData.value.vlaueDrafts.length - 1 <= 0) {
          adkData.value.vlaueDrafts.push(draft.value);
          // console.log('draft saved, first draft');
          // console.log(adkData.value.vlaueDrafts);
          // eslint-disable-next-line no-plusplus
          IndexVal.value++;
          // eslint-disable-next-line no-plusplus
          display.value++;
          Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: 'Your draft has been successfully saved!'
          });
          // success = true;
        } else if (adkData.value.vlaueDrafts.length - IndexVal.value === 2) {
          // console.log('first item');
        } else if (
          adkData.value.vlaueDrafts[draftNum].onePitch !==
            adkData.value.vlaueDrafts[draftNum - 1].onePitch ||
          adkData.value.vlaueDrafts[draftNum].elevatorPitch !==
            adkData.value.vlaueDrafts[draftNum - 1].elevatorPitch
        ) {
          adkData.value.vlaueDrafts.push(draft.value);
          // console.log('draft saved');
          // console.log(adkData.value.vlaueDrafts);
          // success = true;
          // eslint-disable-next-line no-plusplus
          IndexVal.value++;
          // eslint-disable-next-line no-plusplus
          display.value++;
          Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: 'Your draft has been successfully saved!'
          });
        } else {
          // console.log('duplicate data');
          // success = false;
          Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: 'Your draft has been successfully saved!'
          });
        }
      } else {
        Swal.fire({
          icon: 'error',
          title: 'Oops...',
          text: 'You forgot to write something in!'
        });
      }
    }

    const indexNum = '';

    const finalDraftIndex = ref('');
    function finalDraft() {
      // console.log('saved final draft');

      // console.log(adkData.value.vlaueDrafts[IndexVal.value].finalDraft);
      // const submittedFinal = true;
      adkData.value.vlaueDrafts[IndexVal.value].draftIndex = IndexVal.value;
      // console.log(adkData.value.vlaueDrafts[IndexVal.value].draftIndex);
      adkData.value.vlaueDrafts.splice(
        adkData.value.vlaueDrafts.length - 1,
        0,
        adkData.value.vlaueDrafts[IndexVal.value]
      );
      adkData.value.vlaueDrafts[adkData.value.vlaueDrafts.length - 1].finalDraft = true;
      // console.log(adkData.value.vlaueDrafts[adkData.value.vlaueDrafts.length - 1].finalDraft);
      // adkData.value.vlaueDrafts.push(draft.value);
      // console.log(adkData.value.vlaueDrafts);
      finalDraftSaved.value = 'Final: Draft';
      display.value = IndexVal.value + 1;
      Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: 'Successfully marked as final draft!'
      });
      adkData.value.update(() => ({
        isComplete: true,
        adkIndex: adkIndex
      }))
      // IndexVal.value = adkData.value.vlaueDrafts.length - 1;
    }

    function showDraft(draft: number) {
      // console.log(draft - 1);
      // IndexVal.value = draftIndex;
      // if (IndexVal.value !== draftIndex) {
      //   return draftIndex;
      //   // IndexVal.value = draftIndex;
      // }
      // console.log(adkData.value.vlaueDrafts[draftIndex - 1].innovation);
      // eslint-disable-next-line operator-assignment
      IndexVal.value = adkData.value.vlaueDrafts.length - draft;
      display.value = IndexVal.value + 1;
      // console.log(IndexVal.value);
      // console.log(adkData.value.vlaueDrafts[IndexVal.value].finalDraft);
      if (adkData.value.vlaueDrafts[IndexVal.value + 1].finalDraft === true) {
        finalDraftSaved.value = 'Final: Draft';
        // console.log('this is a final draft');
      } else {
        finalDraftSaved.value = 'Draft';
      }

      return draft;
    }

    const setupInstructions = ref({
      description: '',
      instructions: ['', '', '']
    });

    return {
      studentDocument,
      onePitch: '',
      elevatorPitch: '',
      setupInstructions,
      showInstructions: 'true',
      draftSave,
      IndexVal,
      finalDraft,
      showDraft,
      // draftNum,
      finalDraftSaved,
      indexNum,
      finalDraftIndex,
      display,
      adkData
    };
  }
  // setup() {
  //   const onePitch = ref();
  //   const elevatorPitch = ref();
  //   const setupInstructions = ref({
  //     description: '',
  //     instructions: ['', '', '']
  //   });
  //   const showInstructions = ref(true);
  //   return {
  //     setupInstructions,
  //     showInstructions,
  //     elevatorPitch,
  //     onePitch
  //   };
  // }
});
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
    // margin-bottom: 75px;
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
