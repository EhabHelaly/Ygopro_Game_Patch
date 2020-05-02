--Kairem Che
function c11511321.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xffc),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11511321.splimit)
	c:RegisterEffect(e1)
	--fusion summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_FUSION)
	e2:SetCondition(c11511321.spcon)
	e2:SetOperation(c11511321.spop)
	c:RegisterEffect(e2)
	-- return to Hand (Fusion Summon)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(SUMMON_TYPE_FUSION)
	e3:SetCondition(c11511321.conSP)
	e3:SetOperation(c11511321.retop)
	c:RegisterEffect(e3)
	--dec ATK (Pendulum summon)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(SUMMON_TYPE_PENDULUM)
	e4:SetCondition(c11511321.conSP)
	e4:SetOperation(c11511321.atkop)
	c:RegisterEffect(e4)
	-- return to Hand (Pendulum Effect)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c11511321.thcon)
	e5:SetTarget(c11511321.thtg)
	e5:SetOperation(c11511321.thop)
	c:RegisterEffect(e5)

end
function c11511321.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11511321.spfilter(c)
	return c:IsSetCard(0xffc) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c11511321.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsFacedown() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11511321.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c11511321.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11511321.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetFusionMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c11511321.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
function c11511321.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11511321.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11511321.thfilter,1,nil)
end
function c11511321.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c11511321.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c11511321.filterH(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c11511321.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11511321.filterH, tp, 0, LOCATION_MZONE, nil)
	if g:GetCount() then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c11511321.atkfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c11511321.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tcl=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tcr=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local pScales=0;
	if tcl and tcl:IsSetCard(0xffc) then pScales=pScales+tcl:GetLeftScale() end
	if tcr and tcr:IsSetCard(0xffc) then pScales=pScales+tcr:GetRightScale() end
	local g=Duel.GetMatchingGroup(c11511321.atkfilter, tp, 0, LOCATION_MZONE, nil,e)

	if g:GetCount() then
		local rc=g:GetFirst()
		while rc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(pScales*-100)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e1)
			rc=g:GetNext()
		end
	end
end
