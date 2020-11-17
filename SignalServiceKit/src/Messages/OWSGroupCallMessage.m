//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

#import "OWSGroupCallMessage.h"
#import "TSGroupThread.h"
#import <SignalCoreKit/NSDate+OWS.h>
#import <SignalServiceKit/FunctionalUtil.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSGroupCallMessage ()

@property (nonatomic, getter=wasRead) BOOL read;

@property (nonatomic, nullable) NSString *eraId;
@property (nonatomic, nullable) NSArray<NSString *> *joinedMemberUuids;
@property (nonatomic, nullable) NSString *creatorUuid;

@end

#pragma mark -

@implementation OWSGroupCallMessage

- (instancetype)initWithEraId:(NSString *)eraId
            joinedMemberUuids:(NSArray<NSUUID *> *)joinedMemberUuids
                  creatorUuid:(NSUUID *)creatorUuid
                       thread:(TSGroupThread *)thread
              sentAtTimestamp:(uint64_t)sentAtTimestamp
{
    self = [super initInteractionWithTimestamp:sentAtTimestamp thread:thread];

    if (!self) {
        return self;
    }

    self.eraId = eraId;
    self.joinedMemberUuids = [joinedMemberUuids map:^(NSUUID *uuid) { return uuid.UUIDString; }];
    self.creatorUuid = creatorUuid.UUIDString;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                     creatorUuid:(nullable NSString *)creatorUuid
                           eraId:(nullable NSString *)eraId
                        hasEnded:(BOOL)hasEnded
               joinedMemberUuids:(nullable NSArray<NSString *> *)joinedMemberUuids
                            read:(BOOL)read
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId];

    if (!self) {
        return self;
    }

    _creatorUuid = creatorUuid;
    _eraId = eraId;
    _hasEnded = hasEnded;
    _joinedMemberUuids = joinedMemberUuids;
    _read = read;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    return [super initWithCoder:coder];
}

- (NSArray<SignalServiceAddress *> *)joinedMemberAddresses
{
    return [self.joinedMemberUuids
        map:^(NSString *uuidString) { return [[SignalServiceAddress alloc] initWithUuidString:uuidString]; }];
}

- (SignalServiceAddress *)creatorAddress
{
    return [[SignalServiceAddress alloc] initWithUuidString:self.creatorUuid];
}

- (OWSInteractionType)interactionType
{
    return OWSInteractionType_Call;
}

#pragma mark - OWSReadTracking

- (uint64_t)expireStartedAt
{
    return 0;
}

- (BOOL)shouldAffectUnreadCounts
{
    return YES;
}

- (void)markAsReadAtTimestamp:(uint64_t)readTimestamp
                       thread:(TSThread *)thread
                 circumstance:(OWSReadCircumstance)circumstance
                  transaction:(SDSAnyWriteTransaction *)transaction
{

    OWSAssertDebug(transaction);

    if (self.read) {
        return;
    }

    OWSLogDebug(@"marking as read uniqueId: %@ which has timestamp: %llu", self.uniqueId, self.timestamp);

    [self anyUpdateGroupCallMessageWithTransaction:transaction
                                             block:^(OWSGroupCallMessage *groupCallMessage) {
                                                 groupCallMessage.read = YES;
                                             }];

    // Ignore `circumstance` - we never send read receipts for calls.
}

#pragma mark - Methods

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    NSString *creatorDisplayName = [self participantNameForAddress:self.creatorAddress transaction:transaction];
    NSString *formatString = NSLocalizedString(@"GROUP_CALL_STARTED_MESSAGE", @"Text explaining that someone started a group call. Embeds {{call creator display name}}");
    return [NSString stringWithFormat:formatString, creatorDisplayName];
}

- (NSString *)systemTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    NSString *memberString = nil;
    BOOL isCreatorInCall = [self.joinedMemberUuids containsObject:self.creatorUuid];

    NSString *(^participantName)(NSUInteger) = ^NSString *(NSUInteger idx) {
        if (self.joinedMemberAddresses.count <= idx) {
            OWSFailDebug(@"Out of bounds");
            return nil;
        }
        SignalServiceAddress *address = self.joinedMemberAddresses[idx];
        return [self participantNameForAddress:address transaction:transaction];
    };

    if (self.hasEnded) {
        memberString = NSLocalizedString(@"GROUP_CALL_ENDED_MESSAGE", @"Text in conversation view for a group call that has since ended");

    } else if (self.joinedMemberUuids.count >= 4) {
        NSString *formatString = NSLocalizedString(@"GROUP_CALL_MANY_PEOPLE_HERE_FORMAT", @"Text explaining that there are more than three people in the group call. Embeds two {member name}s and memberCount-2");
        memberString = [NSString stringWithFormat:formatString, participantName(0), participantName(1), (self.joinedMemberUuids.count - 2)];

    } else if (self.joinedMemberUuids.count == 3) {
        NSString *formatString = NSLocalizedString(@"GROUP_CALL_THREE_PEOPLE_HERE_FORMAT", @"Text explaining that there are three people in the group call. Embeds two {member name}s");
        memberString = [NSString stringWithFormat:formatString, participantName(0), participantName(1)];

    } else if (self.joinedMemberUuids.count == 2) {
        NSString *formatString = NSLocalizedString(@"GROUP_CALL_TWO_PEOPLE_HERE_FORMAT", @"Text explaining that there are two people in the group call. Embeds two {member name}s");
        memberString = [NSString stringWithFormat:formatString, participantName(0), participantName(1)];

    } else if (isCreatorInCall) {
        // If the originator is the only participant, the wording is "X started a group call" instead of "X is in a group call"
        NSString *formatString = NSLocalizedString(@"GROUP_CALL_STARTED_MESSAGE", @"Text explaining that someone started a group call. Embeds {{call originator display name}}");
        memberString = [NSString stringWithFormat:formatString, participantName(0)];

    } else if (self.joinedMemberUuids.count == 1) {
        NSString *formatString = NSLocalizedString(@"GROUP_CALL_ONE_PERSON_HERE_FORMAT", @"Text explaining that there is one person in the group call. Embeds {member name}");
        memberString = [NSString stringWithFormat:formatString, participantName(0)];

    } else {
        memberString = NSLocalizedString(@"GROUP_CALL_ENDED_MESSAGE", @"Text in conversation view for a group call that has since ended");
    }

    return memberString;
}


- (void)updateWithEraId:(NSString *)eraId
      joinedMemberUuids:(NSArray<NSUUID *> *)joinedMemberUuids
            creatorUuid:(NSUUID *)creatorUuid
               hasEnded:(BOOL)hasEnded
            transaction:(SDSAnyWriteTransaction *)transaction
{
    [self anyUpdateGroupCallMessageWithTransaction:transaction
                                             block:^(OWSGroupCallMessage *groupCallMessage) {
                                                 groupCallMessage.eraId = eraId;
                                                 groupCallMessage.joinedMemberUuids = [joinedMemberUuids
                                                     map:^(NSUUID *uuid) { return uuid.UUIDString; }];
                                                 groupCallMessage.creatorUuid = creatorUuid.UUIDString;
                                                 groupCallMessage.hasEnded = hasEnded;
                                             }];
}

#pragma mark - Private

- (NSString *)participantNameForAddress:(SignalServiceAddress *)address transaction:(SDSAnyReadTransaction *)transaction
{
    if (address.isLocalAddress) {
        return NSLocalizedString(@"GROUP_CALL_YOU", "Text describing the local user as a participant in a group call.");
    } else {
        return [SSKEnvironment.shared.contactsManager displayNameForAddress:address transaction:transaction];
    }
}

@end

NS_ASSUME_NONNULL_END
