local Translations = {
    error = {
        ['missing_item'] = 'You Are Missing Something.',
        ['cant_bag'] = 'You Can\'t Bag This Person Right Now.',
        ['cant_zip'] = 'You Can\'t Ziptie This Person Right Now.',
        ['no_zip_item'] = 'You Have Nothing To Cut/Break That With.',
        ['none_nearby'] = 'There Is Nobody Nearby.',
        ['vehicle_zip'] = 'You Can\'t Do That Right Now.',
    },
    info = {
        ['wiggle'] = 'Wiggle Free By \'Pointing\'',
        ['bagged'] = 'You\'re Head Has Been Covered.',
    },
    released = {
        ['bag_off'] = 'You Can See Again',
        ['wigglebag'] = 'You Wiggled The Bag Off',
        ['zipoff'] = 'You Have Been Released',
        ['wigglezip'] = 'You Wiggled Free',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})