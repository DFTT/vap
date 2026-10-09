// QGVAPlayerTests.m
// Tencent is pleased to support the open source community by making vap available.
//
// Copyright (C) 2020 Tencent.  All rights reserved.
//
// Licensed under the MIT License (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
//
// http://opensource.org/licenses/MIT
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

#import <XCTest/XCTest.h>
#import <QGVAPlayer/QGVAPWrapView.h>
#import "../QGVAPlayer/Classes/Controllers/QGAnimatedImageDecodeManager.h"
#import <math.h>

@interface VAPTestAudioPlayer : NSObject
@property (nonatomic, assign) float volume;
@end

@implementation VAPTestAudioPlayer
@end

@interface QGVAPlayerTests : XCTestCase
@end

@implementation QGVAPlayerTests

- (void)testVolumeDefaultsAndBounds {
    UIView *view = [UIView new];
    XCTAssertEqual(view.volume, 1.0f);
    view.volume = 0.4f;
    XCTAssertEqual(view.volume, 0.4f);
    view.volume = NAN;
    XCTAssertEqual(view.volume, 0.4f);
    view.volume = -1.0f;
    XCTAssertEqual(view.volume, 0.0f);
    view.volume = 2.0f;
    XCTAssertEqual(view.volume, 1.0f);
    view.volume = -INFINITY;
    XCTAssertEqual(view.volume, 0.0f);
    view.volume = INFINITY;
    XCTAssertEqual(view.volume, 1.0f);
}

- (void)testVolumeDoesNotEnableMutedAudio {
    UIView *view = [UIView new];
    [view setMute:YES];
    view.volume = 0.8f;
    XCTAssertFalse([(id<QGAnimatedImageDecoderDelegate>)view shouldSetupAudioPlayer]);
    [view setMute:NO];
    XCTAssertTrue([(id<QGAnimatedImageDecoderDelegate>)view shouldSetupAudioPlayer]);
    XCTAssertEqual(view.volume, 0.8f);
    QGAnimatedImageDecodeManager *manager = [QGAnimatedImageDecodeManager new];
    [manager setVolume:0.8f];
    XCTAssertNil([manager valueForKey:@"audioPlayer"]);
}

- (void)testVolumeUpdatesAudioPlayer {
    QGVAPWrapView *view = [[QGVAPWrapView alloc] initWithFrame:CGRectZero];
    [view setMute:NO];
    UIView *innerView = [view valueForKey:@"vapView"];
    QGAnimatedImageDecodeManager *manager = [QGAnimatedImageDecodeManager new];
    VAPTestAudioPlayer *audioPlayer = [VAPTestAudioPlayer new];
    [manager setValue:audioPlayer forKey:@"audioPlayer"];
    [innerView setValue:manager forKey:@"hwd_decodeManager"];
    view.volume = 0.3f;
    XCTAssertEqual(audioPlayer.volume, 0.3f);
    view.volume = 0.0f;
    XCTAssertEqual(audioPlayer.volume, 0.0f);
}

- (void)testDecodedWrapViewKeepsExistingDefaults {
    QGVAPWrapView *view = [[QGVAPWrapView alloc] initWithFrame:CGRectZero];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:view];
    QGVAPWrapView *decodedView = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(decodedView);
    XCTAssertEqual(decodedView.volume, 1.0f);
    XCTAssertFalse(decodedView.autoDestoryAfterFinish);
}

- (void)testWrapVolumeSurvivesInnerViewRecreation {
    QGVAPWrapView *view = [[QGVAPWrapView alloc] initWithFrame:CGRectZero];
    XCTAssertEqual(view.volume, 1.0f);
    view.volume = 0.5f;
    UIView *innerView = [view valueForKey:@"vapView"];
    XCTAssertEqual(innerView.volume, 0.5f);
    view.volume = 2.0f;
    XCTAssertEqual(view.volume, 1.0f);
    view.volume = NAN;
    XCTAssertEqual(view.volume, 1.0f);
    view.volume = 0.5f;
    view.volume = NAN;
    XCTAssertEqual(view.volume, 0.5f);
    XCTAssertEqual(innerView.volume, 0.5f);
    [innerView removeFromSuperview];
    [view setValue:nil forKey:@"vapView"];
    [view setMute:NO];
    UIView *recreatedView = [view valueForKey:@"vapView"];
    XCTAssertNotEqual(innerView, recreatedView);
    XCTAssertEqual(recreatedView.volume, 0.5f);
}

@end
