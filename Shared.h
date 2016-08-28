/*
 * Shared.h
 * VolumeBar9
 *
 * Created by cgm616
 * Copyright (c) 2016 cgm616. All rights reserved.
 */

typedef void(^CompletionBlock)(void);

typedef NS_ENUM(NSInteger, VB9GestureType) {
    VB9GestureTypeSlide,
    VB9GestureTypeTap,
    VB9GestureTypeDoubleTap,
    VB9GestureTypeLongPress
};
