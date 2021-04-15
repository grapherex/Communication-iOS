//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

#import "OWSDisappearingConfigurationUpdateInfoMessage.h"
#import "OWSDisappearingMessagesConfiguration.h"
#import <SignalCoreKit/NSString+OWS.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSDisappearingConfigurationUpdateInfoMessage ()

@property (nonatomic, readonly, nullable) NSString *createdByRemoteName;
@property (nonatomic, readonly) BOOL createdInExistingGroup;
@property (nonatomic, readonly) uint32_t configurationDurationSeconds;

@end

#pragma mark -

@implementation OWSDisappearingConfigurationUpdateInfoMessage

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    return [super initWithCoder:coder];
}

- (instancetype)initWithThread:(TSThread *)thread
                 configuration:(OWSDisappearingMessagesConfiguration *)configuration
           createdByRemoteName:(nullable NSString *)remoteName
        createdInExistingGroup:(BOOL)createdInExistingGroup
{
    self = [super initWithThread:thread messageType:TSInfoMessageTypeDisappearingMessagesUpdate];
    if (!self) {
        return self;
    }

    _configurationIsEnabled = configuration.isEnabled;
    _configurationDurationSeconds = configuration.durationSeconds;

    // At most one should be set
    OWSAssertDebug(!remoteName || !createdInExistingGroup);

    _createdByRemoteName = remoteName;
    _createdInExistingGroup = createdInExistingGroup;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                      bodyRanges:(nullable MessageBodyRanges *)bodyRanges
                    contactShare:(nullable OWSContact *)contactShare
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
              wasRemotelyDeleted:(BOOL)wasRemotelyDeleted
                   customMessage:(nullable NSString *)customMessage
             infoMessageUserInfo:(nullable NSDictionary<InfoMessageUserInfoKey, id> *)infoMessageUserInfo
                     messageType:(TSInfoMessageType)messageType
                            read:(BOOL)read
             unregisteredAddress:(nullable SignalServiceAddress *)unregisteredAddress
    configurationDurationSeconds:(unsigned int)configurationDurationSeconds
          configurationIsEnabled:(BOOL)configurationIsEnabled
             createdByRemoteName:(nullable NSString *)createdByRemoteName
          createdInExistingGroup:(BOOL)createdInExistingGroup
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId
                     attachmentIds:attachmentIds
                              body:body
                        bodyRanges:bodyRanges
                      contactShare:contactShare
                   expireStartedAt:expireStartedAt
                         expiresAt:expiresAt
                  expiresInSeconds:expiresInSeconds
                isViewOnceComplete:isViewOnceComplete
                 isViewOnceMessage:isViewOnceMessage
                       linkPreview:linkPreview
                    messageSticker:messageSticker
                     quotedMessage:quotedMessage
      storedShouldStartExpireTimer:storedShouldStartExpireTimer
                wasRemotelyDeleted:wasRemotelyDeleted
                     customMessage:customMessage
               infoMessageUserInfo:infoMessageUserInfo
                       messageType:messageType
                              read:read
               unregisteredAddress:unregisteredAddress];

    if (!self) {
        return self;
    }

    _configurationDurationSeconds = configurationDurationSeconds;
    _configurationIsEnabled = configurationIsEnabled;
    _createdByRemoteName = createdByRemoteName;
    _createdInExistingGroup = createdInExistingGroup;

    [self sdsFinalizeDisappearingConfigurationUpdateInfoMessage];

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (void)sdsFinalizeDisappearingConfigurationUpdateInfoMessage
{
    // At most one should be set
    OWSAssertDebug(!self.createdByRemoteName || !self.createdInExistingGroup);
}

- (BOOL)shouldUseReceiptDateForSorting
{
    // Use the timestamp, not the "received at" timestamp to sort,
    // since we're creating these interactions after the fact and back-dating them.
    return NO;
}

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    DisappearingMessageToken *newToken =
        [[DisappearingMessageToken alloc] initWithIsEnabled:self.configurationIsEnabled
                                            durationSeconds:self.configurationDurationSeconds];
    return [TSInfoMessage legacyDisappearingMessageUpdateDescriptionWithToken:newToken
                                                      wasAddedToExistingGroup:self.createdInExistingGroup
                                                                  updaterName:self.createdByRemoteName];
}

@end

NS_ASSUME_NONNULL_END
