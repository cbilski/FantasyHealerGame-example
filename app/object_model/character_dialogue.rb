class CharacterDialog
  def self.create_dialog(dialog_id)
    case dialog_id
    when :dialog_text_1
      [
        {portrait:   :player, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:     :npc1, text: "Fell deeds awake!\nNow for wrath, now for ruin!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_3
      [
        {portrait:   :player, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:     :npc1, text: "Why does this feel so ... \nfamiliar?"},
        {portrait:     :npc1, text: "..."},
        {portrait:     :npc1, text: "Fell deeds awake!\nNow for wrath, now for ruin!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_5
      [
        {portrait:   :player, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:     :npc1, text: "Haven't we done this like 4\ntimes already?"},
        {portrait:   :player, text: "We must prevail!\nEXISTENCE depends on us!"},
        {portrait:     :npc1, text: "*shrugs*"},
        {portrait:     :npc1, text: "*breathes deeply*"},
        {portrait:     :npc1, text: "Fell deeds awake!\nNow for wrath, now for ruin!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_7
      [
        {portrait:   :player, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:     :npc1, text: "You've got to open with\nsomething else next time..."},
        {portrait:   :player, text: "I'm not wrong...\nThe omens ARE true!"},
        {portrait:     :npc1, text: "If we're going to keep doing\n*whatever* this is, we should\nmix it up!"},
        {portrait:   :player, text: "..."},
        {portrait:     :npc1, text: "Let's see here..."},
        {portrait:     :npc1, text: "YOU! SHALL NOT! PASS!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_9
      [
        {portrait:   :player, text: "..."},
        {portrait:     :npc1, text: "You're not going to say it?"},
        {portrait:   :player, text: "I thought maybe you could\nsay it this time..."},
        {portrait:     :npc1, text: "..."},
        {portrait:     :npc1, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:   :player, text: "LET'S RUMBLE!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_11
      [
        {portrait:     :npc1, text: "This reminds me of the last\n10 times we did this."},
        {portrait:   :player, text: "It's reminiscent..."},
        {portrait:   :player, text: "But NOT the same..."},
        {portrait:   :player, text: "Which means..."},
        {portrait:   :player, text: "We're learning: growing.\nEach time we stand longer."},
        {portrait:   :player, text: "If we're improving each time...\nWE. CAN. WIN!"},
        {portrait:     :npc1, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:   :player, text: "YAAAAAAAS!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_13
      [
        {portrait:   :player, text: "Dormammu:\nI've come to bargain!"},
        {portrait:     :npc1, text: "(VISIBLE CONFUSION)"},
        {portrait:   :player, text: "Alright. I'll come up with\nsomething else..."},
        {portrait:     :npc1, text: "Fell deeds awake!\nNow for wrath, now for ruin!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_15
      [
        {portrait:   :player, text: "Dormammu:\nI've come to bargain!"},
        {portrait:     :npc1, text: "Really?!"},
        {portrait:   :player, text: "You're right:\nWe're *NOT* going to bargain!"},
        {portrait:   :player, text: "We're going to\nKICK. YOUR. TEETH. IN!"},
        {portrait:     :npc1, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_17
      [
        {portrait:   :player, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:     :npc1, text: "RUSH B! GOGOGO!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    when :dialog_day_19
      [
        {portrait:   :player, text: "The omens are TRUE!\nThe WORLD BLIGHT is upon us!"},
        {portrait:     :npc1, text: "I can feel our power and\nexperience. Victory is\nwithin our grasp!"},
        {portrait:   :player, text: "We will persist: no matter\nhow long it takes!"},
        {portrait:     :npc1, text: "Cry havoc and let slip the\ndogs of war!"},
        {portrait: :skeleton, text: "CONSUME! CONSUME!"},
      ]
    else
      []
    end
  end
end
