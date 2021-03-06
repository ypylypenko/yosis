# SPDX-FileCopyrightText: 2020 Felix Wolfsteller
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class Admin::SiteSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  before_action :set_site_setting, only: [:show, :edit, :update, :destroy]

  # GET /admin/site_settings
  def index
    md_keys = [:intro, :explanation, :privacy_statement, :terms, :impressum,
               :copyright_notice, :about_us, :trial_period_cta,
               :register_cta, :payment_details]
    md_keys.each do |key|
      SiteSetting.find_or_create_by(key: key,
        kind: "markdown",
        value: t('site_settings.' + key.to_s + '.default'))
    end

    SiteSetting.find_or_create_by(key: 'title',
      value: t('site_settings.title.default'))

    SiteSetting.find_or_create_by(key: 'logo',
      value: t('site_settings.logo.default'), kind: 'image')

    SiteSetting.find_or_create_by(key: 'favicon',
      value: t('site_settings.favicon.default'), kind: 'image')

    SiteSetting.find_or_create_by(key: 'favicon-png',
      value: t('site_settings.favicon-png.default'), kind: 'image')

    SiteSetting.find_or_create_by(key: 'favicon-apple-touch',
      value: t('site_settings.favicon-apple-touch.default'), kind: 'image')

    SiteSetting.find_or_create_by(key: 'intro_background',
      value: t('site_settings.intro_background.default'), kind: 'image')

    SiteSetting.find_or_create_by(key: 'your_name',
      value: t('site_settings.your_name.default'), kind: 'string')

    @general_settings    = SiteSetting.where(key: ['copyright_notice', 'title', 'logo', 'favicon', 'favicon-png', 'favicon-apple-touch', 'your_name', 'payment_details'])
    @start_page_settings = SiteSetting.where(key: ['intro', 'intro_background', 'register_cta', 'trial_period_cta'])
    @pages_settings      = SiteSetting.where(key: ['about_us', 'impressum', 'privacy_statement', 'terms', 'explanation'])
  end

  def show
  end

  # GET /admin/site_settings/new
  def new
    @site_setting = SiteSetting.new
  end

  # GET /admin/site_settings/1/edit
  def edit
  end

  # POST /site_settings
  def create
    @site_setting = SiteSetting.new(site_setting_params)

    respond_to do |format|
      if @site_setting.save
        format.html { redirect_to @site_setting, notice: t('.sitesetting-successfully-created') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /site_settings/1
  def update
    respond_to do |format|
      if @site_setting.update(site_setting_params)
        # Nicer redirection, please!
        format.html { redirect_to admin_site_settings_path, notice: t('.site-setting-successfully-updated') }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_setting
      @site_setting = SiteSetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def site_setting_params
      params.require(:site_setting).permit(:key, :value, :image)
    end
end
