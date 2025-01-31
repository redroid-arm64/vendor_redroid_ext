include vendor/redroid_ext/BoardConfig.mk

######################
# common config
######################
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

PRODUCT_COPY_FILES += \
    vendor/redroid_ext/redroid.ext.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/redroid.ext.rc \


######################
# mali config
######################
PRODUCT_PACKAGES += libstdc++.vendor  # https://github.com/redroid-rockchip/aosp_bionic/commit/13123f0a99dba389dd2ed7571acc2ee2a5844dd5

ifneq (,$(filter  mali-tDVx mali-G52 mali-G610, $(TARGET_BOARD_PLATFORM_GPU)))
BOARD_VENDOR_GPU_PLATFORM := bifrost
endif

ifneq (,$(filter  mali-t860 mali-t760, $(TARGET_BOARD_PLATFORM_GPU)))
BOARD_VENDOR_GPU_PLATFORM := midgard
endif

ifeq ($(strip $(TARGET_ARCH)), arm64)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif

# define MPP_BUF_TYPE_DRM 1
# define MPP_BUF_TYPE_ION_LEGACY 2
# define MPP_BUF_TYPE_ION_404 3
# define MPP_BUF_TYPE_ION_419 4
# define MPP_BUF_TYPE_DMA_BUF 5
ifeq ($(TARGET_RK_GRALLOC_VERSION),4)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.mpp_buf_type=1
# Gralloc HAL
PRODUCT_PACKAGES += \
    arm.graphics-V1-ndk_platform.so \
    android.hardware.graphics.allocator@4.0-impl-$(BOARD_VENDOR_GPU_PLATFORM) \
    android.hardware.graphics.mapper@4.0-impl-$(BOARD_VENDOR_GPU_PLATFORM) \
    android.hardware.graphics.allocator@4.0-service

DEVICE_MANIFEST_FILE += \
    device/rockchip/common/manifests/android.hardware.graphics.mapper@4.0.xml \
    device/rockchip/common/manifests/android.hardware.graphics.allocator@4.0.xml
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.mpp_buf_type=1
PRODUCT_PACKAGES += \
    gralloc.$(TARGET_BOARD_HARDWARE) \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

DEVICE_MANIFEST_FILE += \
    device/rockchip/common/manifests/android.hardware.graphics.mapper@2.1.xml \
    device/rockchip/common/manifests/android.hardware.graphics.allocator@2.0.xml
endif

$(call inherit-product, device/rockchip/common/rootdir/rootdir.mk)
$(call inherit-product, device/rockchip/common/modules/mediacodec.mk)
$(call inherit-product, vendor/rockchip/common/device-vendor.mk)


######################
# network config
######################

PRODUCT_PACKAGES += \
    createns2 \
    execns2 \
    ipv6proxy2 \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/network/init.redroid.net.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hw/init.redroid.net.sh \


######################
# wifi config
######################
PRODUCT_SOONG_NAMESPACES += \
    device/generic/goldfish \

PRODUCT_PACKAGES += \
    iw_vendor \
    dhcpclient2 \
    dhcpserver2 \

PRODUCT_PACKAGES += \
    create_radios2 \
    hostapd \
    hostapd_nohidl \
    wpa_supplicant \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/hostapd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/hostapd.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \


######################
# battery config
######################
#
# Power HAL
#
PRODUCT_PACKAGES += \
    android.hardware.power-service.example

#
# PowerStats HAL
#
PRODUCT_PACKAGES += \
    android.hardware.power.stats-service.example

PRODUCT_COPY_FILES += \
    vendor/redroid_ext/battery/init.redroid.battery.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hw/init.redroid.battery.sh \
    $(call find-copy-subdir-files,*,vendor/redroid_ext/battery/power_supply,$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/battery/power_supply) \


######################
# gps config
######################
PRODUCT_PACKAGES += \
    android.hardware.gnss-service

PRODUCT_COPY_FILES += \
    vendor/redroid_ext/gps/init.redroid.gps.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hw/init.redroid.gps.sh \


######################
# gms config
######################
$(call inherit-product-if-exists, vendor/gapps/arm64/arm64-vendor.mk)

# disable setupwizard
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.setupwizard.mode=DISABLED


######################
# zygisk config
######################
$(call inherit-product-if-exists, vendor/magisk/device.mk)
